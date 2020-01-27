//
//  AppDelegate.swift
//  Ticket
//
//  Created by Алексей Морозов on 12.01.2020.
//  Copyright © 2020 Aleksey Morozov. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let version: UInt64 = 0
        var config = Realm.Configuration(
            schemaVersion: version,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < version) {
                    self.firstStart()
                }
            }
        )
        config.deleteRealmIfMigrationNeeded = true
        Realm.Configuration.defaultConfiguration = config
        return true
    }
    
    func firstStart() {
        let groups = Groups()
        let tickets = Tickets()
        let transports = Transports()
        
        DispatchQueue.main.async {
            groups.saveItems()
            tickets.saveItems()
            transports.saveItems()
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

