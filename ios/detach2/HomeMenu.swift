import SwiftUI
struct HomeMenu: View {
    @State var durationString: String = ""
    @State var oldDurationString: String = ""
    var setScreen: (_ screen: String) -> Void
    var startFocusPressed: () -> Void
    var showDurationScreen: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State var editDurationMode: Bool = false
   var validInput: Bool {
    durationString != "00:00"
   }

    var setDurationButtonTopPadding: CGFloat {
        s.home.detachTitleHeight + s.home.detachTitleToTop + s.home.setDurationLabelHeight + s.home.setDurationLabelPaddingTop + s.home.setDurationButtonPaddingTop
    }

    func initSessionDuration() -> String {
        return String(format: "%02d", getSessionDuration() / (60 * 60)) + ":" + String(format: "%02d", (getSessionDuration() % 3600) / 60)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("detach").font(.custom("Georgia-Italic", size: 42)).foregroundColor(Color.tan).frame(width: s.home.detachTitleWidth)

                            Spacer()
                        }
                        .padding(.top, s.home.detachTitleToTop)
                        Text("Set Focus Duration").kerning(-0.65).font(.system(size: 25, weight: .medium, design: .default)).foregroundColor(Color.tan)
                            .frame(width: s.home.setDurationLabelWidth, height: s.home.setDurationLabelHeight)
                            .padding(.top, s.home.setDurationLabelPaddingTop)
                        Rectangle().frame(width: geo.size.width, height: s.home.setDurationButtonHeight).foregroundColor(.clear)
                            .padding(.top, s.home.setDurationButtonPaddingTop)
                    }

                    Button(action: {
                        self.startFocusPressed()
                    }) {
                        HStack(alignment: .center) {
                            Text("Start Focus").font(.system(size: 45, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.tan)
                            Spacer()
                            Image("rightArrow").resizable().frame(width: 52.25, height: 25, alignment: .center)
                        }.frame(width: geo.size.width * 0.9, height: .none, alignment: .leading)
                    }
                    .padding(.top, 40)
                    Button(action: {
                        self.setScreen("SelectApps")
                    }) {
                        HStack(alignment: .center) {
                            Text("Select Apps").font(.system(size: 45, weight: .regular, design: .default)).kerning(-1).foregroundColor(Color.tan)
                            Spacer()
                            Image("rightArrow-thin").resizable().frame(width: 52.25, height: 25, alignment: .center)
                        }.frame(width: geo.size.width * 0.90, height: .none, alignment: .leading)
                    }.padding(.top, 10)
                    Spacer()
                }
                .padding(.horizontal, 25).frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .offset(x: self.editDurationMode ? -1 * (geo.size.width + s.universal.horizontalPadding) : 0)
                VStack {
                    SetDurationButton(durationString: self.$durationString, editDurationMode: self.$editDurationMode){
                        if !self.editDurationMode {
                            self.editDurationMode = true
                            print("in switch to edit. self.durationString: \(self.durationString)")
                            self.oldDurationString = self.durationString
                        }
                    }
                        .frame(width: self.editDurationMode ? geo.size.width : geo.size.width * 0.75)
                    HStack(spacing: 0) {
                        Button(action: {
                            print("cancel pressed.\n\tself.oldDurationString: \(self.oldDurationString)\n\tself.durationString: \(self.durationString)")
                            self.durationString = self.oldDurationString
                            self.editDurationMode = false
                        }) {
                            Text("Cancel").font(.system(size: 20, weight: .semibold, design: .default)).foregroundColor(Color.lightPurple)
                        }
                        .frame(width: (geo.size.width - s.home.setDurationEditorButtonsHSpace) / 2, height: 50).background(Image("bg-blur").resizable()).cornerRadius(7.0)
                        .offset(x: self.editDurationMode ? 0 : -1 * (s.universal.horizontalPadding + (geo.size.width - s.home.setDurationEditorButtonsHSpace) / 2))

                        Rectangle().frame(width: s.home.setDurationEditorButtonsHSpace, height: 50).foregroundColor(Color.clear)
                        Button(action: {
                            let durationSec = calculateDurationSec(duration: durationString)
                            self.editDurationMode = false
                        }) {
                            Text("Save").font(.system(size: 20, weight: .bold, design: .default)).foregroundColor(Color.lightPurple)
                        }.disabled(!self.validInput)
                        .frame(width: (geo.size.width - s.home.setDurationEditorButtonsHSpace) / 2, height: 50).background(Image("bg-blur").resizable()).cornerRadius(7.0)
                        .offset(x: self.editDurationMode ? 0 : (s.universal.horizontalPadding + (geo.size.width - s.home.setDurationEditorButtonsHSpace) / 2))
                    }
                    Spacer()
                }.offset(y: self.editDurationMode ? s.home.setDurationEditorPaddingTop : setDurationButtonTopPadding)
            }
        }.onAppear{
            self.durationString = String(format: "%02d", getSessionDuration() / (60 * 60)) + ":" + String(format: "%02d", (getSessionDuration() % 3600) / 60)
        }
    }
}


struct SetDurationButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var durationString: String
    @Binding var editDurationMode: Bool
    var onTap: () -> Void

    var body: some View {
        GeometryReader { _ in
            Button(action: {
                onTap()
            }) {
                VStack(alignment: .center, spacing: 0) {
                    CustomUIKitTextField(text: self.$durationString, isFirstResponder: self.$editDurationMode)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Rectangle().fill(Color.midPurple).frame(width: 200, height: 1, alignment: .center)
                        Spacer()
                    }.padding(.top, 4)
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        Text("HOURS")
                        Spacer().frame(width: 31, height: 0, alignment: .center)
                        Text("MINUTES")
                        Spacer()
                    }.padding(.top, 5).foregroundColor(Color.midPurple)
                }
            }.frame(height: s.home.setDurationButtonHeight).background(Image("bg-blur").resizable().edgesIgnoringSafeArea([.top, .bottom])).cornerRadius(15.0)
        }.frame(height: s.home.setDurationButtonHeight)
    }
}

struct HomeMenu_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeMenu() { _ in
            } startFocusPressed: {} showDurationScreen: {}.padding(.horizontal, s.universal.horizontalPadding).background(Image("bg-grain").resizable().edgesIgnoringSafeArea(.all))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
            //                .previewDisplayName("iPhone 11")
        }
    }
}
