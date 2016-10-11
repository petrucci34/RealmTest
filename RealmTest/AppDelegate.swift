//
//  AppDelegate.swift
//  RealmTest
//
//  Created by Korhan Bircan on 10/10/16.
//  Copyright © 2016 Korhan Bircan. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        Fabric.with([Twitter.self])

        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
        print("realm URL: \(realmURL.absoluteString)")

        return false
    }
}
