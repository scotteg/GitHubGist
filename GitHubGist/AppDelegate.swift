//
//  AppDelegate.swift
//  GitHubGist
//
//  Created by Scott Gardner on 5/10/17.
//  Copyright © 2017 Scott Gardner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        customizeSplitViewController()
        customizeAppearance()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate {
    
    func customizeSplitViewController() {
        let splitViewController = window!.rootViewController as! UISplitViewController
        splitViewController.delegate = self
        splitViewController.preferredPrimaryColumnWidthFraction = 0.5
        let navigationController = splitViewController.viewControllers.last as! UINavigationController
        let navigationItem = navigationController.topViewController!.navigationItem
        navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        navigationItem.leftItemsSupplementBackButton = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            splitViewController.preferredDisplayMode = .allVisible
        }
    }
    
    func customizeAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1), NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20.0)!]
    }
}

extension AppDelegate: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let gistViewController = (secondaryViewController as? UINavigationController)?.topViewController as? GistViewController else { return false }
        guard gistViewController.gist != nil else { return true }
        return false
    }
}
