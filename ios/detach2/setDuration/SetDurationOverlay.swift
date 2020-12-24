

import Foundation
import SwiftUI

struct SetDurationOverlay: View {
    @Binding var durationString: String
    @State var validInput: Bool = false
    var setDurationString: (_ str: String) -> Void

    @Binding var keyboardVisible: Bool

    var hideOverlay: () -> Void

    func calculateDurationSec(duration: String) -> Int {
        let hours = Int(duration[0] + duration[1])!
        let minutes = Int(duration[3] + duration[4])!
        return hours * 60 * 60 + minutes * 60
    }

    func saveTime(durationString: String) {
        let durationSec = calculateDurationSec(duration: durationString)
        setDurationString(durationString)
        setSessionDuration(duration: durationSec)
        hideOverlay()
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 18, style: .circular).fill(Color.tan).frame(width: geo.size.width, height: geo.size.height + 100)

                VStack(alignment: .leading, spacing: 0.0) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Set Duration").font(.system(size: 25, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.darkBlue)
                            Text("Set how long selected apps will be blocked for.").font(.system(size: 14, weight: .regular, design: .default)).kerning(-1).foregroundColor(Color.darkBlue).padding(.top, 0)
                        }
                        Spacer()
                    }
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        CustomUIKitTextField(text: self.$durationString, validInput: self.$validInput, isFirstResponder: self.$keyboardVisible, placeholder: "00:00") {
                            self.hideOverlay()
                        }
                        Spacer()
                    }.padding(.top, 50)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Rectangle().fill(Color.darkBlue).frame(width: 245, height: 1, alignment: .center)
                        Spacer()
                    }.padding(.top, 0)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("HOURS").foregroundColor(.darkBlue).font(.system(size: 16.8, weight: .regular, design: .default)).kerning(-1)
                        Spacer().frame(width: 31, height: 0, alignment: .center)
                        Text("MINUTES").foregroundColor(.darkBlue).font(.system(size: 16.8, weight: .regular, design: .default)).kerning(-1)
                        Spacer()
                    }.padding(.top, 8)

                    Text("Quick-Set").foregroundColor(.darkBlue)
                        .font(.system(size: 24, weight: .medium, design: .default)).padding(.top, 30)
                    HStack {
                        quickSetButton(width: 0.41 * geo.size.width, numberText: "25", unitText: "MIN") {
                            self.saveTime(durationString: "00:25")
                        }
                        Spacer()
                        quickSetButton(width: 0.41 * geo.size.width, numberText: "45", unitText: "MIN") {
                            self.saveTime(durationString: "00:45")
                        }
                    }.padding(.top, 10)
                    HStack {
                        quickSetButton(width: 0.41 * geo.size.width, numberText: "1", unitText: "HR") {
                            self.saveTime(durationString: "01:00")
                        }
                        Spacer()
                        quickSetButton(width: 0.41 * geo.size.width, numberText: "3", unitText: "HR") {
                            self.saveTime(durationString: "03:00")
                        }
                    }.padding(.top, 10)
                    Spacer()
                }.padding(.horizontal, 20).padding(.top, 50)
            }
        }
    }
}

struct SetDurationOverlayu_Previews: PreviewProvider {
    @State static var keyboardVisible = false
    @State static var durationString = "04:20"

    static var previews: some View {
        Group {
            SetDurationOverlay(durationString: self.$durationString, setDurationString: { _ in

            }, keyboardVisible: self.$keyboardVisible, hideOverlay: {})
                .previewDisplayName("iPhone 11")
        }
    }
}

struct quickSetButton: View {
    var width: CGFloat
    var numberText: String
    var unitText: String
    var onPress: () -> Void

    var body: some View {
        Button(action: {
            self.onPress()
        }) {
                ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.darkBlue)
                        .frame(width: width, height: 70)
                    HStack(alignment: .center, spacing: nil, content: {
                        Text(numberText).foregroundColor(.white).font(.system(size: 40, weight: .heavy, design: .default))
                        Text(unitText).foregroundColor(.white).font(.system(size: 40, weight: .medium, design: .default))

                    })
                }
        }
    }
}
