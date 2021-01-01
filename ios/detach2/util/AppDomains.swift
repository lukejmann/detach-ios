import Foundation
func refreshSupportedApps() {
    detachProvier.request(.fetchAppDomains) { result in
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data
            let statusCode = moyaResponse.statusCode
            if statusCode == 200 {
                do {
                    let res = try JSONDecoder().decode([App].self, from: data)
                    if !res.isEmpty {
                        print("[API] successfully recived and decoded appDomains. length: \(res.count)")
                        setSupportedApps(apps: res)
                    } else {
                        print("[API][ERROR] failed to decoded appDomains. length is zero")
                    }
                } catch {
                    print("[API][ERROR] failed to decode appDomains. err: \(error)")
                }
            }
        case let .failure(error):
            print("[API][ERROR] failure updating appDomains. error: \(error)")
        }
    }
}

public struct App: Codable {
    var Name: String
    var URLs: [String]
}
