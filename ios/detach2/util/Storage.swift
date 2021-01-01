import Foundation
let timerDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.timer")!
let appsDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.blockedApps")!
let userInfoDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.userInfo")!
let kSessionEndDate = "sessionEndDate"
public func getSessionEndDate() -> Date? {
    if let data = timerDefaults.object(forKey: kSessionEndDate) as? Data {
        let decoder = JSONDecoder()
        if let date = try? decoder.decode(Date.self, from: data) {
            return date
        }
    }
    return nil
}

public func setSessionEndDate(date: Date?) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(date) {
        timerDefaults.set(encoded, forKey: kSessionEndDate)
        print("[STORAGE] set SessionEndDate in store. date \(date)")
    } else {
        print("[STORAGE][ERROR] failed to store SessionEndDate")
    }
}

public func clearSessionEndDate() {
    timerDefaults.removeObject(forKey: kSessionEndDate)
}

// Unit: Seconds
let kSessionDuration = "sessionDuration"
public func getSessionDuration() -> Int {
    let endTime = timerDefaults.integer(forKey: kSessionDuration)
    print("[STORAGE] in getSessionDuration. duration: \(endTime)")
    return endTime
}

public func setSessionDuration(duration: Int) {
    print("[STORAGE] in setSessionDuration. setting end time to : \(duration)")
    timerDefaults.set(duration, forKey: kSessionDuration)
}

let kSupportedApps = "supportedApps"
let kSelectedAppNames = "selectedAppNames"
public func getSupportedApps() -> [App] {
    if let data = appsDefaults.object(forKey: kSupportedApps) as? Data {
        let decoder = JSONDecoder()
        if let apps = try? decoder.decode([App].self, from: data) {
            return apps
        }
    }
    return [App]()
}

public func setSupportedApps(apps: [App]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(apps) {
        appsDefaults.set(encoded, forKey: kSupportedApps)
        print("[STORAGE] set supportedApps in store. apps length: \(apps.count)")
    } else {
        print("[STORAGE][ERROR] failed to store supportedApps")
    }
}

public func getSelectedAppNames() -> [String] {
    if let appNames = appsDefaults.array(forKey: kSelectedAppNames) {
        return appNames as! [String]
    }
    return [""]
}

public func setSelectedAppNames(appNames: [String]) {
    print("[STORAGE] in setSelectedAppNames. setting apps to array of length: \(appNames.count)")
    appsDefaults.set(appNames, forKey: kSelectedAppNames)
}

let kUserID = "userID"
public func getUserID() -> String? {
    let userID = userInfoDefaults.string(forKey: kUserID)
    print("[STORAGE] in getUserID. userID: \(String(describing: userID))")
    return userID
}

public func setUserID(userID: String) {
    print("[STORAGE] in setUserID. setting userID to : \(userID)")
    userInfoDefaults.set(userID, forKey: kUserID)
}

let kSessionID = "sessionID"
public func getSessionID() -> String {
    let sessionID = userInfoDefaults.string(forKey: kSessionID)
    print("[STORAGE] in getSessionID. sessionID: \(String(describing: sessionID))")
    return sessionID ?? "N/A sessionID"
}

public func setSessionID(sessionID: String) {
    print("[STORAGE] in setSessionID.setting sessionID to : \(sessionID)")
    userInfoDefaults.set(sessionID, forKey: kSessionID)
}

let kUserAgreedToVPN = "userAgreedToVPN"
public func getUserAgreedToVPN() -> Bool {
    let userAgreedToVPN = userInfoDefaults.bool(forKey: kUserAgreedToVPN)
    print("[STORAGE] in getUserAgreedToVPN. userAgreedToVPN: \(userAgreedToVPN)")
    return userAgreedToVPN
}

public func setUserAgreedToVPN(userAgreedToVPN: Bool) {
    print("[STORAGE] in userAgreedToVPN. Setting userAgreedToVPN to : \(userAgreedToVPN)")
    userInfoDefaults.set(userAgreedToVPN, forKey: kUserAgreedToVPN)
}
