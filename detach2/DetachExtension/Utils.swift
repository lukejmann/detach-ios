
import Foundation

let defaults = UserDefaults(suiteName: "group.com.detachapp.detach2.vpnData")!

let kBlockedDomains = "blockedDomains"
let kRefreshDomains = "refreshDomains"

let kUseAdblock = "useAdblock"
let kRefreshAdblock = "refreshAdblock"
let kRefreshSortedAdBlock = "refreshSortedAdblock"
let kAdBlockDomains = "adblockDomains"
let kSortedAdBlockDomains = "sortedAdBlockDomains"

var userBlockDomains = [String]()
var adBlockDomains = [String]()

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

func shouldAdBlock() -> Bool {
    // TODO: change
    defaults.bool(forKey: kUseAdblock)
}

func getSortedAdblockList() -> [String: [String]] {
    let refresh = defaults.bool(forKey: kRefreshAdblock)

    if refresh {
        Print("REFRESHING ADBLOCK")
        if let domains = defaults.array(forKey: kAdBlockDomains) {
            adBlockDomains = domains as! [String]
            let sortedDomains = genSortedDict(a: adBlockDomains)
            defaults.set(sortedDomains, forKey: kSortedAdBlockDomains)
            defaults.set(false, forKey: kRefreshAdblock)
        }
    } else {
//    Print("NOT REFRESHING ADBLOCK")
    }
    if let sortedDict = defaults.dictionary(forKey: kSortedAdBlockDomains) {
        return sortedDict as! [String: [String]]
    } else {
        return [String: [String]]()
    }
}

func genSortedDict(a: [String]) -> [String: [String]] {
    var FLs = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", ".", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
    var r = [String: [String]]()
    for l in FLs {
        r[l] = [String]()
    }
    for d in a {
        r[String(d.first ?? ".")]!.append(d)
    }
    return r
}
