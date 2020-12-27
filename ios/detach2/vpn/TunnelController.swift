import NetworkExtension
import UIKit
import Willow
let kTunnelLocalizedDescription = "Detach Configuration"
class TunnelController: NSObject {
    static let shared = TunnelController()
    var manager: NETunnelProviderManager?
    override private init() {
        super.init()
        Print("[TUNNEL_CONTROLLER] in TunnelController init ")
        refreshManager()
    }

    func disable() {
        setEnabled(false)
    }

    func sendProxyTestConnection(completion: @escaping () -> Void) {
        print("[TUNNEL_CONTROLLER] pinging apple.com")
        if let url = URL(string: "https://apple.com") {
            var request = URLRequest(url: url)
            request.httpMethod = "HEAD"

            URLSession(configuration: .default)
                .dataTask(with: request) { (_, response, error) -> Void in
                    completion()
                }
                .resume()
        }
    }


    func enable(completion: @escaping (_ success: Bool) -> Void) {
        TunnelController.shared.setEnabled(true) { error in
            if error != nil {
                print("[TUNNEL_CONTROLLER][ERROR] error enabling proxy. error: \(error)")
                completion(false)
                return
            }
            if TunnelController.shared.status() == .connected {
                print("[TUNNEL_CONTROLLER] proxy successfully enabled without ping")
                completion(true)
                return
            } else {
                self.sendProxyTestConnection {
                    if TunnelController.shared.status() == .connected {
                        print("[TUNNEL_CONTROLLER] proxy successfully enabled with ping 1")
                        completion(true)
                        return
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.sendProxyTestConnection {
                                if TunnelController.shared.status() == .connected {
                                    print("[TUNNEL_CONTROLLER] proxy successfully enabled with ping 2")
                                    completion(true)
                                    return
                                } else {
                                    completion(false)
                                    return
                                }
                            }

                        }
                    }
                }
            }
        }
    }

        //    func restart(completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        //         Print("MARK: In TunnelController restart ")
        //         // Don't let this affect userWantsFirewallOn/Off config
        //         TunnelController.shared.setEnabled(false, completion: {  error in
        //             if error != nil {
        //                 Print("Error disabling on Firewall restart: \(error!)")
        //             }
        //            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
        //                TunnelController.shared.setEnabled(true, completion: {
        //                    error in
        //                    if error != nil {
        //                        Print("Error enabling on Firewall restart: \(error!)")
        //                    }
        //                    completion(error)
        //                })
        //            }
        //
        //         })
        //     }



        func refreshManager(completion: @escaping (_ error: Error?) -> Void = { _ in }) {
            Print("[TUNNEL_CONTROLLER] in TunnelController refreshManager ")
            // get the reference to the latest manager in Settings
            NETunnelProviderManager.loadAllFromPreferences { (managers, error) -> Void in
                if let managers = managers, !managers.isEmpty {
                    if self.manager == managers[0] {
                        Print("[TUNNEL_CONTROLLER] encountered same manager while refreshing manager, not replacing it.")
                        completion(nil)
                    }
                    self.manager = nil
                    self.manager = managers[0]
                }
                completion(error)
            }
        }

        func status() -> NEVPNStatus {
            if manager != nil {
                return manager!.connection.status
            } else {
                return .invalid
            }
        }

        func setEnabled(_ enabled: Bool, isUserExplicitToggle _: Bool = false, completion: @escaping (_ error: Error?) -> Void = { _ in }) {
            Print("[TUNNEL_CONTROLLER] in TunnelController setEnabled. enabled: \(enabled)")
            let vpnManager = NEVPNManager.shared()
            vpnManager.loadFromPreferences(completionHandler: { (_ error: Error?) -> Void in
                if error != nil{
                    Print("[TUNNEL_CONTROLLER][ERROR] in loadFromPreferences completion. error: \(String(describing: error))")
                    completion(error)
                }
                NETunnelProviderManager.loadAllFromPreferences { (managers, error) -> Void in
                    if error != nil{
                        Print("ERROR: In loadAllFromPreferences. error: \(String(describing: error))")
                        completion(error)
                    }
                    if let managers = managers, !managers.isEmpty {
                        self.manager = nil
                        self.manager = managers[0]
                    } else {
                        self.manager = nil
                        self.manager = NETunnelProviderManager()
                        self.manager!.protocolConfiguration = NETunnelProviderProtocol()
                    }
                    let manager = self.manager!
                    manager.localizedDescription = "Detach Tunnel"
                    manager.protocolConfiguration?.serverAddress = "Detach"
                    manager.isEnabled = enabled
                    manager.isOnDemandEnabled = enabled
                    let connectRule = NEOnDemandRuleConnect()
                    connectRule.interfaceTypeMatch = .any
                    manager.onDemandRules = [connectRule]
                    manager.saveToPreferences(completionHandler: { (error) -> Void in
                        if error != nil{
                            Print("ERROR: in saveToPreferences completion. error: \(String(describing: error))")
                            completion(error)
                        }
                        completion(error)
                    })
                }
            })
        }
    }

//
//func connectProxy(i: Int, callback: @escaping (_ success: Bool) -> Void) {
//    let seconds = 8.0
//    if i > 2 {
//        print("[TUNNEL_CONTROLLER][ERROR] unable to connect to proxy after \(i + 1) \(seconds) second attempts")
//        callback(false)
//        return
//    }
//    TunnelController.shared.setEnabled(true) { _ in
//        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//            let status = TunnelController.shared.status()
//            if status == .connected {
//                print("[TUNNEL_CONTROLLER] connected to proxy after \(i + 1) \(seconds) second attempts")
//                callback(true)
//                return
//            } else {
//                connectProxy(i: i + 1, callback: callback)
//            }
//        }
//    }
//}

// func connectProxy(callback: @escaping (_ success: Bool) -> Void) {
//    TunnelController.shared.setEnabled(true) { _ in
//        let status = TunnelController.shared.status()
//        if status == .connected {
//            callback(true)
//        } else {
//            callback(false)
//        }
//    }
// }
