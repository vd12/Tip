//
//  AppDelegate.swift
//  Tip
//
//  Created by V on 2/18/17.
//  Copyright © 2017 vova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var didEnterBackgroundDate: NSDate?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        didEnterBackgroundDate = NSDate()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if var beforeDate = didEnterBackgroundDate {
            let afterDate = NSDate()
            beforeDate = beforeDate.addingTimeInterval(600)
            if afterDate.compare(beforeDate as Date) == ComparisonResult.orderedDescending {
                let nav = self.window?.rootViewController as! UINavigationController;
                let vc = nav.topViewController as! ViewController
                vc.billField.text = "0.00"
                vc.calculateTip(AnyClass.self)
            }
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let nav = self.window?.rootViewController as! UINavigationController;
        let vc = nav.topViewController as! ViewController
        let defaultBill = Double(vc.billField.text!) ?? 0
        let defaults = UserDefaults.standard
        defaults.set(defaultBill, forKey: "defaultBill")
        defaults.synchronize()
    }


}

