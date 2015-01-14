//
//  AppDelegate.swift
//  Field QA2
//
//  Created by John Jusayan on 8/11/14.
//  Copyright (c) 2014 University of Nevada, Reno. All rights reserved.
//

import UIKit
import CoreData

let CurrentUserIdKey = "CurrentUserIdKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var currentUser: Person?


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as UINavigationController
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = .AllVisible

        let masterNavigationController = splitViewController.viewControllers[0] as UINavigationController
        let controller = masterNavigationController.topViewController as MasterViewController
        controller.managedObjectContext = DataManager.sharedManager.managedObjectContext
        
        self.window?.tintColor = UIColor(red:0.093, green:0.732, blue:0.194, alpha:1.000)
        
        if let userId = NSUserDefaults.standardUserDefaults().objectForKey(CurrentUserIdKey) as? String {
            var error: NSError?
            let fetchRequest = NSFetchRequest(entityName: "Person")
            fetchRequest.predicate = NSPredicate(format: "uniqueIdentifier == %@", userId)
            let users = DataManager.sharedManager.managedObjectContext?.executeFetchRequest(fetchRequest, error: &error)
            if let user = users?[0] as? Person {
                currentUser = user
            }
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        self.saveContext()

        /*
        let data = CDJSONExporter.exportContext(DataManager.sharedManager.managedObjectContext, auxiliaryInfo: nil)
        
        
        if let json = NSJSONSerialization.JSONObjectWithData(data, options: .allZeros, error: nil) {
            println("\(json)")
        }
        else {
            println("Failed")
        }


        
        CDJSONExporter.importData(data, toContext: DataManager.sharedManager.managedObjectContext, clear: true)

        */
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication!) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Split view

    func splitViewController(splitViewController: UISplitViewController!, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }


    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = DataManager.sharedManager.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

