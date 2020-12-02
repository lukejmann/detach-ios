//
//  SessionManager.swift
//  detach2
//
//  Created by Luke Mann on 8/13/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation

var timerEnd = Date()

func uploadSession(endTimeUnix: Int, completion: @escaping (Bool) -> Void) {
    let appNames = getSelectedAppNames()
    setupBlockedDomains(appNames: appNames)

    let sessionCreateOpt = SessionCreateOpt(userID: getUserID(), endTime: endTimeUnix, deviceToken: deviceToken)
    detachProvier.request(.createSession(opt: sessionCreateOpt)) { result in

        print("result in createSession res: \(result)")
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data // Data, your JSON response is probably in here!
            let statusCode = moyaResponse.statusCode // Int - 200, 401, 500, etc

            if statusCode == 200 {
                print("data: \(data)")
                do {
                    let res = try JSONDecoder().decode(SessionCreateRes.self, from: data)
                    print("res: \(res)")
                    if res.success {
                        timerEnd = Date(timeIntervalSince1970: TimeInterval(endTimeUnix))
                        setSessionID(sessionID: res.sessionID)
                        if getSubStatus()?.status != "active"{
                            setTrialSession(trialSession: TrialSession(date: Date()))
                        }
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
