//
//  AppDelegate.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import UIKit
import GoogleMaps
import GoogleMobileAds
import GooglePlaces

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBar.appearance().isTranslucent = false
        sleep(1)
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GMSPlacesClient.provideAPIKey("AIzaSyA6zhP2dUBGYTQl1dJ8pjSJoyk67KnQil8")
        GMSServices.provideAPIKey("AIzaSyA15EOFQw3HMJqU6NB9I0KSx6bxdaOq-zU")
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

}
