

import Foundation

func isBlocked(domain: String) -> Bool {
    let start = CFAbsoluteTimeGetCurrent()

    var blockedDomains = getUserDomains()
    Print("getUserDomains: \(blockedDomains)")
    for blockedDomain in blockedDomains {
        if domain.hasSuffix(blockedDomain) {
            let diff = CFAbsoluteTimeGetCurrent() - start
            Print("\(domain) USER BLOCKED (\(diff) s)")
            return true
        }
    }

    if shouldAdBlock() {
        let sortedDomains = getSortedAdblockList()
        let domainsToCheck = sortedDomains[String(domain.first ?? ".")] ?? [String]()
        for blockedDomain in domainsToCheck {
            if domain.hasSuffix(blockedDomain) {
                let diff = CFAbsoluteTimeGetCurrent() - start
                Print("\(domain) AD BLOCKED by \(blockedDomain) (\(diff) s)")
                return true
            }
        }
    } else {
        Print("ADBLOCK DISABLED")
    }
    let diff = CFAbsoluteTimeGetCurrent() - start
    Print("\(domain) ALLOWED (\(diff) s)")
    return false
}
