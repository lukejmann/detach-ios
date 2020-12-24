//
//  AppDelegate.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import AuthenticationServices
import SwiftyStoreKit
import UIKit

var deviceToken = "default"
// var userLoggedInOnOpen = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications()

        let appleIDProvider = ASAuthorizationAppleIDProvider()

        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                    break // do nothing
                }
            }
        }
        SwiftyStoreKit.retrieveProductsInfo(["com.detachapp.ios1.onemonth"]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(result.error)")
            }
        }
        
        let proxyStatus = TunnelController.shared.status()
        if Date() > getSessionEndDate() ?? Date().addingTimeInterval(.infinity){
            TunnelController.shared.disable()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, _ in

                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken dToken: Data) {
        let tokenParts = dToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        deviceToken = token
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

    ////   fetch notifications in the background and foreground
//    -(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification
//    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//      NSLog(@"[notif]didReceiveRemoteNotification %@", notification);
//    [RNCPushNotificationIOS didReceiveRemoteNotification:notification fetchCompletionHandler:completionHandler];
//    NSLog(@"[notif]Notification Body %@", notification);
    //  completionHandler(UIBackgroundFetchResultNewData);
//    }
//    func application(_: UIApplication, didReceiveRemoteNotification notif: [AnyHashable: Any], fetchCompletionHandler completion: @escaping (UIBackgroundFetchResult) -> Void) {
//        Print("in notifDidReceiveRemoteNotification. notif: \(notif)")
//        print("in notifDidReceiveRemoteNotification. notif: \(notif)")
//
//        if Date() > timerEnd {
//            print("in notifDidReceiveRemoteNotification. notif: \(notif)")
//            print("disabling VPN")
//            TunnelController.shared.disable()
//        }
//        completion(.newData)
//    }

    func application(
        _ notif: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completion:
        @escaping (UIBackgroundFetchResult) -> Void)
    {
        print("in didReceiveRemoteNotification. notif: \(notif). userInfo: \(userInfo)")
        if Date() > getSessionEndDate() ?? Date().addingTimeInterval(.infinity) {
            print("in notifDidReceiveRemoteNotification. notif: \(notif)")
            print("disabling VPN")
            TunnelController.shared.disable()
        }
        completion(.newData)
    }
}
