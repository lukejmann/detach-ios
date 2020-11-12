//
//  AppDomains.swift
//  detach2
//
//  Created by Luke Mann on 8/15/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation

func refreshSupportedApps() {
    detachProvier.request(.fetchAppDomains) { result in
        print("result in fetchAppDomains callback: \(result)")
        switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data // Data, your JSON response is probably in here!
                let statusCode = moyaResponse.statusCode
                if statusCode == 200 {
                    do {
                        print("status code is 200. decoding appDomains \n\n\n")
                        let res = try JSONDecoder().decode([App].self, from: data)
                        print("res: \(res)")
                        if res.count > 0 {
//                            setSessionID(sessionID: res.sessionID)
                            print("successfully decoded appDomains: \(res)")
                            setSupportedApps(apps: res)
//                            completion(true)
                        } else {
                            print("failed to decoded appDomains. length is zero")
//                            completion(false)
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
