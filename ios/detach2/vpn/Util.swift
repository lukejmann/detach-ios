import Foundation
let defaults = UserDefaults(suiteName: "group.com.detachapp.ios1.vpnData")!
let kBlockedDomains = "blockedDomains"
let kRefreshDomains = "refreshDomains"
func setVPNDomains(domains: [String]) {
    Print("[TUNNEL_CONTROLLER] in setVPNDomains. setting domains to : \(domains)")
    defaults.set(domains, forKey: kBlockedDomains)
    defaults.set(true, forKey: kRefreshDomains)
}
