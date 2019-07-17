//
//  AppDelegate.swift
//  AnImediate
//
//  Created by 川村周也 on 2019/06/24.
//  Copyright © 2019 AI_Love_DeepLearning. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dataManager = DataManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        //自動ログイン
        if Auth.auth().currentUser != nil { //もしもユーザがログインしていたら
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateInitialViewController()
            
            self.window?.rootViewController = initialViewController
            
            self.window?.makeKeyAndVisible()
        }
        
        //Realmのマイグレーション処理
        
        var config = Realm.Configuration(
            schemaVersion : 3, //データの構造が変わったらここを変える
            migrationBlock : { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 {
                    /*
                    var nextID = 0
                    migration.enumerateObjects(ofType: UserInfo.className()) { oldObject, newObject in
                        newObject!["id"] = String(nextID)
                        nextID += 1
                    }
                    migration.enumerateObjects(ofType: Work.className()) { oldObject, newObject in
                        newObject!["id"] = String(nextID)
                        nextID += 1
                    }
                    migration.enumerateObjects(ofType: WatchData.className()) { oldObject, newObject in
                        newObject!["id"] = String(nextID)
                        nextID += 1
                    }*/
                }
        }
        )
        
        Realm.Configuration.defaultConfiguration = config
        config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        
        let realm = try! Realm()
        
        if realm.objects(UserInfo.self).isEmpty {
            // Firebaseからアニメデータを取得
            self.dataManager.getWork()
        }
        
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

