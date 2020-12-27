import AuthenticationServices
import SwiftyStoreKit
import UIKit
var deviceToken = "default"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForPushNotifications()

        return true
    }

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, _ in
                if granted {
                    print("[DEVICE] notifications permissions granted")
                }
                else {
                    print("[DEVICE][ERROR] notifications permissions granted")

                }
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken dToken: Data) {
        let tokenParts = dToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("[DEVICE] device token: \(token)")
        deviceToken = token
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

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
