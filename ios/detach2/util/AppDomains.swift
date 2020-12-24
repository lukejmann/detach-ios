

import Foundation

func refreshSupportedApps() {
    detachProvier.request(.fetchAppDomains) { result in
        print("result in fetchAppDomains callback: \(result)")
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data
            let statusCode = moyaResponse.statusCode
            if statusCode == 200 {
                do {
                    print("status code is 200. decoding appDomains \n\n\n")
                    let res = try JSONDecoder().decode([App].self, from: data)
                    print("res: \(res)")
                    if !res.isEmpty {
                        print("successfully decoded appDomains: \(res)")
                        setSupportedApps(apps: res)

                    } else {
                        print("failed to decoded appDomains. length is zero")
                    }

                } catch {
                    print("failed to decode appDomains. err: \(error)")
                }
            }
        case let .failure(error):
            print("failure updating appDomains")
        }
    }
}

public struct App: Codable {
    var Name: String
    var URLs: [String]
}
