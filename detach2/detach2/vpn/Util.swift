//
//  TunnelUtilities.swift
//  Detach
//
//  Created by Luke Mann on 3/12/20.
//

import Foundation

let defaults = UserDefaults(suiteName: "group.com.detachapp.ios1.vpnData")!

let kBlockedDomains = "blockedDomains"
let kRefreshDomains = "refreshDomains"
//
//func getBlockedDomains() -> [String] {
//    if let domains = defaults.array(forKey: kBlockedDomains) {
//        Print("MARK: in getBlockedDomains. domains: \(domains)")
//        return domains as! [String]
//    }
//    Print("MARK: in getBlockedDomains. failed to get domains")
//
//    return Array()
//}

func setVPNDomains(domains: [String]) {
    Print("MARK: in setVPNDomains. setting domains to : \(domains)")
    defaults.set(domains, forKey: kBlockedDomains)
    defaults.set(true, forKey: kRefreshDomains)
}
