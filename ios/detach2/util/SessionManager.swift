

import Foundation

func uploadSession(endTime: Date, completion: @escaping (Bool) -> Void) {
    let appNames = getSelectedAppNames()
    setupBlockedDomains(appNames: appNames)
    let sessionCreateOpt = SessionCreateOpt(userID: getUserID(), endTime: Int(endTime.timeIntervalSince1970), deviceToken: deviceToken)
    detachProvier.request(.createSession(opt: sessionCreateOpt)) { result in
        print("result in createSession res: \(result)")
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data
            let statusCode = moyaResponse.statusCode
            if statusCode == 200 {
                print("data: \(data)")
                do {
                    let res = try JSONDecoder().decode(SessionCreateRes.self, from: data)
                    print("res: \(res)")
                    if res.success {
                        setSessionID(sessionID: res.sessionID)
                        print("successfully started session \(res.sessionID)")
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    print("err: \(error)")
                }

            } else {
                print("bad code in createSession res: \(statusCode)")
                completion(true)
            }

        case let .failure(error):
            print("error in createSession res: \(error)")
            completion(false)
        }
    }
}

func setupBlockedDomains(appNames: [String]) {
    print("in setupBlockedDomains. appNames: \(appNames)")
    var domains = [String]()
    print("supported apps :\(getSupportedApps())")
    getSupportedApps().forEach { app in
        if appNames.contains(app.Name.lowercased()) {
            app.URLs.forEach { url in
                domains.append(url)
            }
        }
    }
    setVPNDomains(domains: domains)
}

public struct SessionCreateRes: Decodable {
    var success: Bool
    var sessionID: String
}
