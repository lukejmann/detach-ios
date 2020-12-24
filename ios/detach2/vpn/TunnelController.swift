import NetworkExtension
import UIKit
import Willow
let kTunnelLocalizedDescription = "Detach Configuration"
class TunnelController: NSObject {
    static let shared = TunnelController()
    var manager: NETunnelProviderManager?
    override private init() {
        super.init()
        Print("MARK: In TunnelController init ")
        refreshManager()
    }

    func disable() {
        setVPNDomains(domains: [""])
        setEnabled(false)
    }

    func refreshManager(completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        Print("MARK: In TunnelController refreshManager ")
        // get the reference to the latest manager in Settings
        NETunnelProviderManager.loadAllFromPreferences { (managers, error) -> Void in
            if let managers = managers, !managers.isEmpty {
                if self.manager == managers[0] {
                    Print("Encountered same manager while refreshing manager, not replacing it.")
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

    func restart(completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        Print("MARK: In TunnelController restart ")
        // Don't let this affect userWantsFirewallOn/Off config
        TunnelController.shared.setEnabled(false, completion: {
            error in
            // TODO: Handle the error (throw?)
            if error != nil {
                Print("Error disabling on Firewall restart: \(error!)")
            }
            TunnelController.shared.setEnabled(true, completion: {
                error in
                if error != nil {
                    Print("Error enabling on Firewall restart: \(error!)")
                }
                completion(error)
            })
        })
    }

    func setEnabled(_ enabled: Bool, isUserExplicitToggle _: Bool = false, completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        Print("MARK: In TunnelController setEnabled")
        let vpnManager = NEVPNManager.shared()
        vpnManager.loadFromPreferences(completionHandler: { (_ error: Error?) -> Void in
            Print("MARK: in loadFromPreferences completion. error: \(error)")
            NETunnelProviderManager.loadAllFromPreferences { (managers, error) -> Void in
                Print("MARK: In loadAllFromPreferences. error: \(error)")
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
                    Print("MARK: in saveToPreferences completion. error: \(error)")
                    completion(error)
                })
            }
        })
    }
}

func connectProxy(i: Int, callback: @escaping (_ success: Bool) -> Void) {
    let seconds = 1.0
    if i >= 4 {
        callback(false)
        return
    }
    TunnelController.shared.setEnabled(true) { _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let status = TunnelController.shared.status()
            if status == .connected {
                callback(true)
                return
            } else {
                connectProxy(i: i + 1, callback: callback)
            }
        }
    }
}
