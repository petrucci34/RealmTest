//
//  TimelineViewCellAdapter.swift
//  CoreDataTest
//
//  Created by Korhan Bircan on 10/9/16.
//  Copyright © 2016 Korhan Bircan. All rights reserved.
//

import UIKit

struct TimelineViewCellAdapter {
    static func configure(tweetCell: TweetCell?, tweet: Tweet?) {
        guard let tweetCell = tweetCell, let tweet = tweet else {
            return
        }

        if let screenName = tweet["screenName"] as? String {
            tweetCell.user.text = screenName
        }

        if let createdAt = tweet["createdAt"] as? NSDate {
            tweetCell.date.text = TimelineResponseMapper.dateToString(createdAt)
        }

        if let text = tweet["text"] as? String {
            tweetCell.content.text = text
        }

        if let favoriteCount = tweet["favoriteCount"] as? Int {
            tweetCell.favoriteCount.text = "\(favoriteCount)"
        }
    }
}
