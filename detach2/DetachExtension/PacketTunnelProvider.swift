import NEKit
import NetworkExtension
import Willow

class LDObserverFactory: ObserverFactory {
    override func getObserverForProxySocket(_ socket: ProxySocket) -> Observer<ProxySocketEvent>? {
        Print("[tunnel] In getObserverForProxySocket. socket: \(socket)")

        return LDProxySocketObserver()
    }

    class LDProxySocketObserver: Observer<ProxySocketEvent> {
        override func signal(_ event: ProxySocketEvent) {
            switch event {
            case let .receivedRequest(session, socket):
                Print("[tunnelEvent] readData. session: \(session). socket: \(socket)")
                if let session = socket.session {
                    if isBlocked(domain: session.host) {
                        socket.forceDisconnect()
                    }
                } else {
                    if isBlocked(domain: session.host) {
                        socket.forceDisconnect()
                    }
                }
            case let .readData(data, on: socket):
                Print("[tunnelEvent] readData. data: \(data). socket: \(socket)")
                if let session = socket.session {
                    if isBlocked(domain: session.host) {
                        socket.forceDisconnect()
                    }
                }
            case let .wroteData(data, on: socket):
                Print("[tunnelEvent] readData. data: \(data). socket: \(socket)")
                if let session = socket.session {
                    if isBlocked(domain: session.host) {
                        socket.forceDisconnect()
                    }
                }
            case let .askedToResponseTo(adapter, on: socket):
                Print("[tunnelEvent] readData. adapter: \(adapter). socket: \(socket)")
                if let session = socket.session {
                    if isBlocked(domain: session.host) {
                        socket.forceDisconnect()
                    }
                }
            case let .readyForForward(socket):
                Print("[tunnelEvent] readyForForward.  socket: \(socket)")
                if let session = socket.session {
                    if isBlocked(domain: session.host) {
                        socket.forceDisconnect()
                    }
                }
            case let .errorOccured(error, on: socket):
                Print("[tunnelEvent] errorOccured. error: \(error). socket: \(socket)")
                if let session = socket.session {
                    if isBlocked(domain: session.host) {
                        socket.forceDisconnect()
                    }
                }

            default:
                Print("[tunnel] In signal. event: \(event)")
            }
        }
    }
}

class PacketTunnelProvider: NEPacketTunnelProvider {
    let proxyServerPort: UInt16 = 9090
    let proxyServerAddress = "127.0.0.1"
    var proxyServer: GCDHTTPProxyServer!

    // MARK: - OVERRIDES

    override func startTunnel(options _: [String: NSObject]?, completionHandler: @escaping (Error?) -> Void) {
//        let seconds = 15.0
//        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        // Put your code which should be executed with a delay here

        Print("MARK: in startTunnel")
        if proxyServer != nil {
            proxyServer.stop()
        }
        proxyServer = nil

        let settings = NEPacketTunnelNetworkSettings(tunnelRemoteAddress: proxyServerAddress)
        settings.mtu = NSNumber(value: 1500)

        // Start MARK: from OldPacketTunnelProvider

        //      let ipv4Settings = NEIPv4Settings.init(addresses: ["10.0.0.8"], subnetMasks: ["255.255.255.0"])
        //      ipv4Settings.includedRoutes = [NEIPv4Route]()
        //      let ipv6Settings = NEIPv6Settings.init(addresses: ["fe80:1ca8:5ee3:4d6d:aaf5"], networkPrefixLengths: [64])
        //      ipv6Settings.includedRoutes = [NEIPv6Route]()

        //      settings.ipv4Settings = ipv4Settings;
        //      settings.ipv6Settings = ipv6Settings;

        // End MARK: from OldPacketTunnelProvider

        let proxySettings = NEProxySettings()

        proxySettings.httpEnabled = true
        proxySettings.httpServer = NEProxyServer(address: proxyServerAddress, port: Int(proxyServerPort))

        // MARK: might want to change

        proxySettings.httpsEnabled = true
        proxySettings.httpsServer = NEProxyServer(address: proxyServerAddress, port: Int(proxyServerPort))
        proxySettings.excludeSimpleHostnames = false
        proxySettings.exceptionList = []
        proxySettings.matchDomains = [""]
        //    proxySettings.matchDomains = getUserDomains()

        settings.dnsSettings = NEDNSSettings(servers: ["127.0.0.1"])
        settings.proxySettings = proxySettings
        RawSocketFactory.TunnelProvider = self
        ObserverFactory.currentFactory = LDObserverFactory()

        setTunnelNetworkSettings(settings, completionHandler: { error in
            guard error == nil else {
                Print("Error setting tunnel network settings \(error)")
                completionHandler(error)
                return
            }

            self.proxyServer = GCDHTTPProxyServer(address: IPAddress(fromString: self.proxyServerAddress), port: Port(port: self.proxyServerPort))
            do {
                try self.proxyServer.start()
                completionHandler(nil)
            } catch let proxyError {
                Print("Error starting proxy server \(proxyError)")
                completionHandler(proxyError)
            }
        })
//        }
    }

    override func stopTunnel(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        Print("In Tunnel. In stopTunnel")

        DNSServer.currentServer = nil
        RawSocketFactory.TunnelProvider = nil
        ObserverFactory.currentFactory = nil
        proxyServer.stop()
        proxyServer = nil
        Print("DetachTunnel: error on stopping: \(reason.rawValue)")
        completionHandler()
        exit(EXIT_SUCCESS)
    }
}
