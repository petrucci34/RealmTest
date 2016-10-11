//
//  Tweet.swift
//  RealmTest
//
//  Created by Korhan Bircan on 10/10/16.
//  Copyright © 2016 Korhan Bircan. All rights reserved.
//

import Foundation

struct Tweet {
    var createdAt: NSDate?
    var favoriteCount: Int64
    var text: String?
    var tweetId: Int64
    var screenName: String?
}
