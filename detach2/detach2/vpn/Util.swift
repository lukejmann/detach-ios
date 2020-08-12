//
//  TunnelUtilities.swift
//  Detach
//
//  Created by Luke Mann on 3/12/20.
//

import Foundation

let defaults = UserDefaults(suiteName: "group.com.detachapp.detach2.vpnData")!

let kBlockedDomains = "blockedDomains"
let kRefreshDomains = "refreshDomains"

let kUseAdblock = "useAdblock"
let kRefreshAdblock = "refreshAdblock"
let kAdBlockDomains = "adblockDomains"

func getBlockedDomains() -> [String] {
    if let domains = defaults.array(forKey: kBlockedDomains) {
        Print("MARK: in getBlockedDomains. domains: \(domains)")
        return domains as! [String]
    }
    Print("MARK: in getBlockedDomains. failed to get domains")

    return Array()
}

func setBlockedDomains(domains: [String]) {
    Print("MARK: in setBlockedDomains. setting domains to : \(domains)")
    defaults.set(domains, forKey: kBlockedDomains)
    defaults.set(true, forKey: kRefreshDomains)
}

func setUseAdblock(enabled: Bool) {
    defaults.set(enabled, forKey: kUseAdblock)
}

func setAdblockDomainList(domains: [String]) {
    defaults.set(domains, forKey: kAdBlockDomains)
    defaults.set(true, forKey: kRefreshAdblock)
}
