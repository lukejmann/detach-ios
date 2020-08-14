import Foundation

let timerDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.timer")!

let appsDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.blockedApps")!

let userInfoDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.userInfo")!

let kEndTime = "timerEndTime"

public func getEndTime() -> Int {
    let endTime = timerDefaults.integer(forKey: kEndTime)
    print("in getEndTime. endTime: \(endTime)")
    return endTime
}

public func setEndTime(endTime: Int) {
    print("in setEndTime. setting end time to : \(endTime)")
    defaults.set(endTime, forKey: kEndTime)
}

let kSupportedApps = "supportedApps"
let kSelectedAppNames = "selectedAppNames"

public func getSupportedApps() -> [App] {
    if let apps = appsDefaults.array(forKey: kSupportedApps) {
        print("in getSupportedApps. supported apps: \(apps)")
        return apps as! [App]
    }
    print("in getSupportedApps. failed to apps")

    return [App]()
}

public func setSupportedApps(apps: [App]) {
    print("in setSupportedApps. setting apps to : \(apps)")
    appsDefaults.set(apps, forKey: kSupportedApps)
}

public func getSelectedAppNames() -> [String] {
    if let appNames = appsDefaults.array(forKey: kSelectedAppNames) {
        print("in getSelectedAppNames. selected app names: \(appNames)")
        return appNames as! [String]
    }
    print("in getSelectedAppNames. failed to apps")

    return ["instagram"]
}

public func setSelectedAppNames(appNames: [String]) {
    print("in setSelectedAppNames. setting apps to : \(appNames)")
    appsDefaults.set(appNames, forKey: kSelectedAppNames)
}

public struct App {
    var name: String
    var domains: [String]
}

let kUserID = "userID"

public func getUserID() -> String {
    let userID = userInfoDefaults.string(forKey: kUserID)
    print("in getUserID. userID: \(userID)")
    return userID ?? "N/A userID"
}

public func setUserID(userID: String) {
    print("in setUserID. setting userID to : \(userID)")
    userInfoDefaults.set(userID, forKey: kUserID)
}

let kSessionID = "sessionID"

public func getSessionID() -> String {
    let sessionID = userInfoDefaults.string(forKey: kSessionID)
    print("in getSessionID. sessionID: \(sessionID)")
    return sessionID ?? "N/A sessionID"
}

public func setSessionID(sessionID: String) {
    print("in setSessionID.setting sessionID to : \(sessionID)")
    userInfoDefaults.set(sessionID, forKey: kSessionID)
}
