import Foundation

let timerDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.timer")!

let appsDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.blockedApps")!

let userInfoDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.userInfo")!

let kSessionEndDate = "sessionEndDate"

public func getSessionEndDate() -> Date? {
    if let data = timerDefaults.object(forKey: kSessionEndDate) as? Data {
        let decoder = JSONDecoder()
        if let date = try? decoder.decode(Date.self, from: data) {
            print("sessionEndDate: \(date)")
            return date
        }
    }
    return nil
}

public func setSessionEndDate(date: Date) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(date) {
        timerDefaults.set(encoded, forKey: kSessionEndDate)
        print("set SessionEndDate in store. date \(date)")
    } else {
        print("failed to store SessionEndDate")
    }
}

public func clearSessionEndDate() {
    timerDefaults.removeObject(forKey: kSessionEndDate)
}

// in seconds
let kSessionDuration = "sessionDuration"

public func getSessionDuration() -> Int {
    let endTime = timerDefaults.integer(forKey: kSessionDuration)
    print("in getSessionDuration. duration: \(endTime)")
    return endTime
}

public func setSessionDuration(duration: Int) {
    print("in setSessionDuration. setting end time to : \(duration)")
    timerDefaults.set(duration, forKey: kSessionDuration)
}

let kSupportedApps = "supportedApps"
let kSelectedAppNames = "selectedAppNames"

public func getSupportedApps() -> [App] {
    if let data = appsDefaults.object(forKey: kSupportedApps) as? Data {
        let decoder = JSONDecoder()
        if let apps = try? decoder.decode([App].self, from: data) {
            print("apps: \(apps)")
            return apps
        }
    }
    return [App]()
}

public func setSupportedApps(apps: [App]) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(apps) {
        appsDefaults.set(encoded, forKey: kSupportedApps)
        print("set supportedApps in store. apps \(apps)")
    } else {
        print("failed to store supportedApps")
    }
}

public func getSelectedAppNames() -> [String] {
    if let appNames = appsDefaults.array(forKey: kSelectedAppNames) {
//        print("in getSelectedAppNames. selected app names: \(appNames)")
        return appNames as! [String]
    }
    print("in getSelectedAppNames. failed to apps")

    return ["instagram"]
}

public func setSelectedAppNames(appNames: [String]) {
    print("in setSelectedAppNames. setting apps to : \(appNames)")
    appsDefaults.set(appNames, forKey: kSelectedAppNames)
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

let kUserAgreedToVPN = "userAgreedToVPN"

public func getUserAgreedToVPN() -> Bool {
    let userAgreedToVPN = userInfoDefaults.bool(forKey: kUserAgreedToVPN)
    print("in getUserAgreedToVPN. userAgreedToVPN: \(userAgreedToVPN)")
    return userAgreedToVPN ?? false
}

public func setUserAgreedToVPN(userAgreedToVPN: Bool) {
    print("in userAgreedToVPN. Setting userAgreedToVPN to : \(userAgreedToVPN)")
    userInfoDefaults.set(userAgreedToVPN, forKey: kUserAgreedToVPN)
}

