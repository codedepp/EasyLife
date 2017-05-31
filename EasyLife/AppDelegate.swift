//
//  AppDelegate.swift
//  EasyLife
//
//  Created by Lee Arromba on 12/04/2017.
//  Copyright © 2017 Pink Chicken Ltd. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var dataManager: DataManager

    override init() {
        dataManager = DataManager.shared
        super.init()
        setupNotifications()
    }
    
    deinit {
        tearDownNotifications()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        #if DEBUG
            debugPrint("DEBUG BUILD")
        #endif
        
        Fabric.with([Crashlytics.self])
        
        do {
            try Analytics.shared.setup()
        } catch _ {
            debugPrint("Analytics setup failed")
        }
        Analytics.shared.startSession()
        dataManager.load()

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
        dataManager.save()
    }
    
    // MARK: - private
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidReceiveFatalError(_:)), name: .applicationDidReceiveFatalError, object: nil)
    }
    
    private func tearDownNotifications() {
        NotificationCenter.default.removeObserver(self, name: .applicationDidReceiveFatalError, object: nil)
    }
    
    @objc private func applicationDidReceiveFatalError(_ notification: Notification) {
        log("applicationDidReceiveFatalError \(notification.object ?? "nil")")
        if let window = window, let error = notification.object as? Error, let fatalViewController = UIStoryboard.components.instantiateViewController(withIdentifier: "FatalViewController") as? FatalViewController {
            fatalViewController.error = error
            window.rootViewController = fatalViewController
            Analytics.shared.sendErrorEvent(error, classId: AppDelegate.self)
        }
    }
}