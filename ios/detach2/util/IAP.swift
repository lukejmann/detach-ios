//
//  IAP.swift
//  detach2
//
//  Created by Luke Mann on 8/21/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation
import SwiftyStoreKit

// TODO: server doesn't recieve appleReceipt var
func checkUserReceipt(completion: @escaping (_ success: Bool) -> Void) {
    SwiftyStoreKit.fetchReceipt(forceRefresh: true) { result in
        switch result {
        case let .success(receiptData):
            let encryptedReceipt = receiptData.base64EncodedString(options: [])
            print("Fetch receipt success.")
            let opt = CheckReceiptOpt(userID: getUserID(), appleReciept: encryptedReceipt)
            detachProvier.request(.checkReceipt(opt: opt)) { result in
                print("checkReceipt completion result: \(result)")
                switch result {
                case let .success(moyaResponse):
                    print("checkReceipt successful.")
                    let data = moyaResponse.data // Data, your JSON response is probably in here!
                    let statusCode = moyaResponse.statusCode
                    if statusCode == 200 {
                        do {
                            print("status code is 200. decoding checkReceipt.")
                            let res = try JSONDecoder().decode(CheckReceiptRes.self, from: data)
                            print("res: \(res)")
                            if res.success {
//                                print("successfully checked receipt subStatus: \(res.subStatus.status)")
//                                                            setSupportedApps(apps: res)
                                setSubStatus(status: res.subStatus)
                                completion(true)
                            } else {
                                print("failed to decoded checkReceipt res.")
                                completion(false)
                            }

                        } catch {
                            print("failed to decode checkReceipt. err: \(error)")
                        }
                    }
                case let .failure(error):
                    print("failure calling checkReceipt")
                }
            }
        case let .error(error):
            print("Fetch receipt failed: \(error)")
        }
    }
}

public struct CheckReceiptRes: Decodable {
    var subStatus: SubStatus
    var success: Bool
}

public class SubStatus: Codable {
    // "active" or "inactive"
    var status: String
    var subDate: Int
}

public struct TrialSession: Codable {
    var date: Date
}
