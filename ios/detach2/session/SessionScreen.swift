import SwiftUI
import Combine

struct SessionScreen: View {
    @Binding var endDate: Date?
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    var setScreen: (_ screen: String) -> Void
    
    var sessionCompleted: Bool {
                endDate == nil ? true : Date() > endDate!
    }

    @State var countDownStr: String = "N/A"
    @Environment(\.colorScheme) var colorScheme



    func dateToCountdownStr(endDateOpt: Date?) -> String {
        if let endDate = endDateOpt as? Date {
            let now = Date()
            let secondsDiff = Int(endDate.timeIntervalSince(now))
            let hours = Int(secondsDiff / 3600)
            let minutes = Int((secondsDiff % 3600) / 60)
            let seconds = (secondsDiff % 3600) % 60
            return "\(String(format: "%02d", hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
        } else {
            return "N/A"
        }
    }

    func endSession() {
        setScreen("HomeMenu")
        clearSessionEndDate()
        TunnelController.shared.disable()
    }

    func sessionCancelled() {
        endSession()
        cancelSession() { success in
            if success {
                //
            }
            else {
                //
            }
        }
        
    }

    func donePressed() {
        endSession()
    }

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                if !sessionCompleted {
                    Text("Focus Session Started").font(.system(size: 25, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.tan)
                    Text(self.countDownStr + "  ").font(.newYorkXL(size: 60.0)).foregroundColor(Color.tan).padding(.top, 15).animation(.spring())
                        .frame(width: 350, height: .none, alignment: .leading)
                    Spacer()
                } else {
                    Text("Focus Session Completed!").font(.system(size: 25, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.tan)
                }
                HStack {
                    Spacer()
                    if !sessionCompleted {
                        Button(action: {
                            self.sessionCancelled()
                        }) {
                            HStack(alignment: .center, spacing: nil, content: {
                                Image("cancelIcon").resizable().frame(width: 15, height: 15, alignment: .center)
                                Text("Cancel Session").foregroundColor(.darkBlue).font(.system(size: 18, weight: .medium, design: .default))
                            }).frame(width: 185, height: 44).overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.darkBlue, lineWidth: 1)
                            )
                        }
                    } else {
                        Button(action: {
                            self.donePressed()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 7.0, style: .continuous)
                                    .fill(Color.clear)
                                    .background(Image("bg-blur").resizable()).cornerRadius(7.0)
                                    .frame(width: 122, height: 44)
                                HStack(alignment: .center, spacing: nil, content: {
                                    Image("checkIcon").resizable().frame(width: 15, height: 15, alignment: .center)
                                    Text("Done").foregroundColor(.lightPurple).font(.system(size: 18, weight: .bold, design: .default))
                                })
                            }
                        }.padding(.top, 30)
                    }
                }.padding(.trailing, 17)
                if sessionCompleted { Spacer() }
            }.onReceive(timer) { _ in
                self.countDownStr = dateToCountdownStr(endDateOpt: self.endDate)
            }.padding(.top, geo.size.height * 0.13).frame(width: nil, height: geo.size.height * 0.7, alignment: .center)
        }
    }
}

struct SessionScreen_Previews: PreviewProvider {
    static var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()

    @State static var endDate: Date? = nil
    static var previews: some View {
        SessionScreen(endDate: self.$endDate, timer: timer, setScreen: { _ in
        }).padding(.horizontal, s.universal.horizontalPadding).background(Image("bg-grain").resizable())
        .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
        .previewDisplayName("iPhone 11 Pro")
    }
}
