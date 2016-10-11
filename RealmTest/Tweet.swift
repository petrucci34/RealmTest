//
//  Tweet.swift
//  RealmTest
//
//  Created by Korhan Bircan on 10/10/16.
//  Copyright © 2016 Korhan Bircan. All rights reserved.
//

import Foundation
import RealmSwift

class Tweet: Object {
    var createdAt: NSDate? = nil
    dynamic var favoriteCount = 0
    var text: String? = nil
    dynamic var tweetId = -1
    var screenName: String? = nil

    override static func primaryKey() -> String? {
        return "tweetId"
    }
}
