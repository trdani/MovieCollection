//
//  AppDelegate.swift
//  MovieCollection
//
//  Created by Trisha Dani on 5/18/20.
//  Copyright © 2020 Trisha Dani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
    
    // called when the application has been left (download data to csv)
    func applicationDidEnterBackground(_ application: UIApplication) {
        // export data to a csv
        
    }
    
    // MARK: - For handling file import
    
    var rawData = String()
    var fileImported = false
    
    // allows file to be loaded in from Files app on phone
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //testing
        print ("Reached AppDelegate")
        let needTo = url.startAccessingSecurityScopedResource()
        do {
            let inBetweenData = try Data(contentsOf: url)
            rawData = String(data: inBetweenData, encoding: String.Encoding.utf8) ?? "no data"
            fileImported = true
        } catch(let error) {
            print(error)
        }
        if needTo {
            url.stopAccessingSecurityScopedResource()
            
        }
        return true
    }
    
    func getRawDataFromFile() -> String {
        return rawData
    }

}

