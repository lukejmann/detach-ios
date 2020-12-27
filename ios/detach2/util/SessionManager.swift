import Foundation
func startSession(endTime: Date, completion: @escaping (Bool) -> Void) {
    let appNames = getSelectedAppNames()
    setupBlockedDomains(appNames: appNames)
    if let userID = getUserID() {
        let sessionCreateOpt = SessionCreateOpt(userID: userID, endTime: Int(endTime.timeIntervalSince1970), deviceToken: deviceToken)
        detachProvier.request(.createSession(opt: sessionCreateOpt)) { result in
            //            print("result in createSession res: \(result)")
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    //                    print("data: \(data)")
                    do {
                        let res = try JSONDecoder().decode(SessionCreateRes.self, from: data)
                        //                        print("res: \(res)")
                        if res.success {
                            setSessionID(sessionID: res.sessionID)
                            print("[API] successfully started session. session ID: \(res.sessionID)")
                            completion(true)
                        } else {
                            print("[API][ERROR] error decoding createSession response. error: \(statusCode)")
                            completion(false)
                        }
                    } catch {
                        print("err: \(error)")
                    }
                } else {
                    print("[API][ERROR] error in createSession. status code: \(statusCode)")
                    completion(false)
                }
            case let .failure(error):
                print("[API][ERROR] error in createSession. error: \(error)")
                completion(false)
            }
        }
    } else {
        // MARK: handle err (no user ID)
    }
}

func cancelSession(completion: @escaping (Bool) -> Void) {
    if let userID = getUserID() {
        let sessionID = getSessionID()
        let opt = SessionCancelOpt(userID: userID, sessionID: sessionID)
        detachProvier.request(.cancelSession(opt: opt)) { result in
//            if statusCode == 200 {

//            }
            switch result{
            case let .success(moyaResponse):
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    print("[API] successfully cancelled session")
                    completion(true)
                } else {
                    print("[API][ERROR] error cancelling session. status code: \(statusCode)")
                    completion(false)
                }
            case let .failure(error):
                print("[API][ERROR] error cancelling session. error: \(error)")
                completion(false)

            }
        }
    } else {
        print("[API][ERROR] error fetching userID in cancelSession")
    }
}



func setupBlockedDomains(appNames: [String]) {
    print("[SESSION] in setupBlockedDomains. selected app names length: \(appNames.count)")
    var domains = [String]()
    let supportedApps = getSupportedApps()
    print("[SESSION] in setupBlockedDomains. supportedApps length: \(supportedApps.count)")
    supportedApps.forEach { app in
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
