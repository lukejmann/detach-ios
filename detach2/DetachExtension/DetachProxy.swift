//import Foundation
//import NEKit
//
///// The HTTP proxy server.
//public final class DetachProxy: GCDProxyServer {
//    /**
//     Create an instance of HTTP proxy server.
//
//     - parameter address: The address of proxy server.
//     - parameter port:    The port of proxy server.
//     */
//    override public init(address: IPAddress?, port: NEKit.Port) {
//        Print("[tunnel] In Detach Proxy init. address: \(address). port: \(port)")
//
//        super.init(address: address, port: port)
//    }
//
//    /**
//     Handle the new accepted socket as a HTTP proxy connection.
//
//     - parameter socket: The accepted socket.
//     */
//    override public func handleNewGCDSocket(_ socket: GCDTCPSocket) {
//        Print("[tunnel] In handleNewGCDSocket. socket: \(socket)")
//    }
//}
