//
//  TimelineViewController.swift
//  CoreDataTest
//
//  Created by Korhan Bircan on 10/9/16.
//  Copyright © 2016 Korhan Bircan. All rights reserved.
//

import UIKit
import TwitterKit

class TimelineViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    private var clientError : NSError?
    private var isLoadingTimeline = false
    private var dataSource = TimelineDataSource()
    private var ascending = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a pull-to-refresh control.
        tableView.refreshControl = UIRefreshControl()
        if let refreshControl = tableView.refreshControl {
            refreshControl.addTarget(self, action: #selector(TimelineViewController.loadTimeline), forControlEvents: .ValueChanged)
        }

        // Hide empty row separators.
        tableView.tableFooterView = UIView(frame: .zero)

        // Add Refresh and Sort buttons.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: #selector(loadTimeline))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sort", style: .Plain, target: self, action: #selector(sortByDate))
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Initially hide the search bar.
        if let searchBarHeight = searchBar?.frame.size.height {
            tableView.contentOffset = CGPoint(x: 0, y: searchBarHeight)
        }

        dataSource.reload(ascending)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TimelineViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(TweetCell.identifier) else {
            return UITableViewCell()
        }

        if let tweet = dataSource.tweetAtIndexPath(indexPath) {
            TimelineViewCellAdapter.configure(cell as? TweetCell, tweet: tweet)
        }

        return cell
    }
}

// MARK: - UISearchbarDelegate
extension TimelineViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            dataSource.reload(ascending)
        } else {
            dataSource.filter(searchText)
        }
        tableView.reloadData()
    }
}

// MARK: - private methods
private extension TimelineViewController {
    @objc func reloadData() {
        tableView.reloadData()
    }

    @objc func sortByDate() {
        ascending = !ascending
        dataSource.reload(ascending)
        tableView.reloadData()
    }

    @objc func loadTimeline() {
        guard Session.sharedInstance.isUserLoggedIn,
            let client = Session.sharedInstance.client,
            let timelineEndpoint = Session.sharedInstance.timelineEndpoint else {
            tableView.refreshControl?.endRefreshing()
            tableView.reloadData()
                showLoginAlert()

            return
        }

        if isLoadingTimeline {
            return
        }

        let request = client.URLRequestWithMethod("GET", URL: timelineEndpoint, parameters: nil, error: &clientError)
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            self.isLoadingTimeline = false

            if let refreshControl = self.tableView.refreshControl {
                refreshControl.endRefreshing()
            }

            if connectionError != nil  || data == nil{
                print("Error: \(connectionError)")
                return
            }

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    TimelineResponseMapper.parseResponse(json)

                    dispatch_async(dispatch_get_main_queue(), { 
                        self.tableView.reloadData()
                    })
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                }
            })
        }
    }

    func showLoginAlert() {
        let alertController = UIAlertController(title: "Please login", message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}
