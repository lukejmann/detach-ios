import Combine
import NetworkExtension
import SwiftUI
struct StatusIndicator: View {
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    @Binding var proxyStatus: NEVPNStatus
    @Binding var cScreen: String
    var proxyStatusText: String {
        switch proxyStatus {
        case .connected:
            return "Connected"
        case .connecting:
            return "Connecting"
        case .disconnected:
            return "Not Connected"
        case .disconnecting:
            return "Disconnecting"
        case .invalid:
            return "Not Connected"
        case .reasserting:
            return "Reasserting"
        }
    }
    

    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .trailing, spacing: 5) {
                Text("Distraction-Blocking Proxy").kerning(-0.5).font(.system(size: 14, weight: .bold, design: .default)).foregroundColor(Color.tan)
                HStack(alignment: .center) {
                    ZStack {
                        switch self.proxyStatus {
                        case .connected:
                            Image("greenStatus").resizable().frame(width: 16, height: 16, alignment: .center)
                        case .connecting:
                            YellowStatus(proxyStatus: self.$proxyStatus)
                        case .disconnecting:
                            YellowStatus(proxyStatus: self.$proxyStatus)
                        default:
                            Image("greyStatus").resizable().frame(width: 8, height: 8, alignment: .center)
                        }
                    }.frame(width: 16, height: 16).animation(.none)
                    Text(self.proxyStatusText).kerning(-0.4).font(.system(size: 14, weight: .medium, design: .default)).foregroundColor(Color.tan)
                }
            }.frame(width: 173, height: 33, alignment: .center).onReceive(timer) { _ in
                self.proxyStatus = TunnelController.shared.status()
            }.animation(.spring())
        }
    }
}

struct StatusIndicator_Previews: PreviewProvider {
    static var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State static var proxyStatus: NEVPNStatus = .connecting
    @State static var cScreen: String = "SelectApps"
    static var previews: some View {
        StatusIndicator(timer: self.timer, proxyStatus: self.$proxyStatus, cScreen: self.$cScreen).background(Image("bg-grain").resizable())
    }
}
