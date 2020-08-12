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

    let diff = CFAbsoluteTimeGetCurrent() - start
    Print("\(domain) ALLOWED (\(diff) s)")
    return false
}
