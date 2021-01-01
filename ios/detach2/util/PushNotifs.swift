import Foundation
import UserNotifications
import AuthenticationServices

class RegistrationHelper {
    static let shared = RegistrationHelper()

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



}

func checkNotifSettings (completion: @escaping (Bool) -> Void) {
    var isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
    if !isRegisteredForRemoteNotifications {
        let center = UNUserNotificationCenter.current()
        var notifSuccess = false
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if !granted {
                print("[PUSHNOTIFS][ERROR] failed to get notif permissions. error: \(error)")
                completion(false)
                return
            }
            if granted{
                print("[PUSHNOTFIS] permissions granted")
                print("isRegisteredForRemoteNotifications 1: \(isRegisteredForRemoteNotifications)")
               completion(true)
                return
            }
        }
    }
    return
}
