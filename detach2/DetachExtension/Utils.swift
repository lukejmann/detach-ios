
import Foundation

let defaults = UserDefaults(suiteName: "group.com.detachapp.detach2.vpnData")!

let kBlockedDomains = "blockedDomains"
let kRefreshDomains = "refreshDomains"

var userBlockDomains = [String]()

func getUserDomains() -> [String] {
    let refresh = defaults.bool(forKey: kRefreshDomains)
    Print("in getUserDomains. refresh: \(refresh)")

    if refresh {
        if let domains = defaults.array(forKey: kBlockedDomains) {
            userBlockDomains = domains as! [String]
            Print("in getUserDomains. userBlockDomains from storage: \(userBlockDomains)")
            defaults.set(false, forKey: kRefreshDomains)
            return domains as! [String]
        } else {
            Print("returning empty 1")

            return []
        }
    } else {
        Print("returning userBlockDomains")
        return userBlockDomains
    }
    Print("returning empty 2")

    return Array()
}
