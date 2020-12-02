import Foundation

let timerDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.timer")!

let appsDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.blockedApps")!

let userInfoDefaults = UserDefaults(suiteName: "group.com.detachapp.ios1.userInfo")!

let kEndTime = "timerEndTime"

var supportedApps = [App]()

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
    }
    else {
        print("failed to store supportedApps")
    }
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

let kSubStatus = "subStatus"

public func getSubStatus() -> SubStatus? {
    if let data = appsDefaults.object(forKey: kSubStatus) as? Data {
        let decoder = JSONDecoder()
        if let subStatus = try? decoder.decode(SubStatus.self, from: data) {
            return subStatus
        }
    }
    return nil
}

public func setSubStatus(status: SubStatus) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(status) {
        appsDefaults.set(encoded, forKey: kSubStatus)
        print("set sub status in store")
    }
    else {
        print("failed to store sub status")
    }
}

let kTrialSession = "trialSession"

public func getTrialSession() -> TrialSession? {
    if let data = userInfoDefaults.object(forKey: kTrialSession) as? Data {
        let decoder = JSONDecoder()
        if let trialSession = try? decoder.decode(TrialSession.self, from: data) {
            return trialSession
        }
    }
    return nil
}

public func setTrialSession(trialSession: TrialSession) {
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(trialSession) {
        userInfoDefaults.set(encoded, forKey: kTrialSession)
        print("set trialSession in store")
    }
    else {
        print("failed to store trialSession")
    }
}

// public func setSupportedApps(apps: [App]) {
//    supportedApps = apps
//    return
//
//            // TODO: add UserDefaults support
//            print("in setSupportedApps. setting apps to arr of len: \(apps.count)")
//    do {
//        let appsData = try NSKeyedArchiver.archivedData(withRootObject: apps, requiringSecureCoding: false)
//        appsDefaults.set(appsData, forKey: kSupportedApps)
//    }
//    catch {
//        print("failed to set supported apps. failed to archive data")
//    }
// }
