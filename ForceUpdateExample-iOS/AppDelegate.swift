//
//  AppDelegate.swift
//  ForceUpdateExample-iOS
//
//  Created by Shaiful Islam on 1/22/21.
//  Copyright © 2021 Shaiful Islam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(appUpdateAvailable())
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
    
    func appUpdateAvailable() -> Bool
    {
        guard let info = Bundle.main.infoDictionary,
            let identifier = info["CFBundleIdentifier"] as? String else {
                return false
        }
        
        let storeInfoURL: String = "http://itunes.apple.com/lookup?bundleId=\(identifier)&country=za"
        var upgradeAvailable = false
        // Get the main bundle of the app so that we can determine the app's version number
        let bundle = Bundle.main
        if let infoDictionary = bundle.infoDictionary {
            // The URL for this app on the iTunes store uses the Apple ID for the  This never changes, so it is a constant
            let urlOnAppStore = NSURL(string: storeInfoURL)
            if let dataInJSON = NSData(contentsOf: urlOnAppStore! as URL) {
                // Try to deserialize the JSON that we got
                if let dict: NSDictionary = try? JSONSerialization.jsonObject(with: dataInJSON as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: AnyObject] as NSDictionary? {
                    if let results:NSArray = dict["results"] as? NSArray {
                        if let version = (results[0] as! [String:Any])["version"] as? String {
                            // Get the version number of the current version installed on device
                            if let currentVersion = infoDictionary["CFBundleShortVersionString"] as? String {
                                // Check if they are the same. If not, an upgrade is available.
                                print("\(version)")
                                if version != currentVersion {
                                    upgradeAvailable = true
                                }
                            }
                        }
                    }
                }
            }
        }
        return upgradeAvailable
    }


}

