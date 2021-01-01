import SwiftUI
struct HomeMenu: View {
    @Binding var currentScreen: String
    @State var durationString: String = ""
    @State var oldDurationString: String = ""
    var setScreen: (_ screen: String) -> Void
    var startFocusPressed: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State var editDurationMode: Bool = false
    
   var validInput: Bool {
    durationString != "00:00"
   }

    var setDurationButtonTopPadding: CGFloat {
        s.home.detachTitleHeight + s.home.detachTitleToTop + s.home.setDurationButtonPaddingTop
    }

    func refactorDurationString() {
        let minutes = Int(self.durationString[3] + self.durationString[4]) ?? 0
        let hours = Int(self.durationString[0] + self.durationString[1]) ?? 0

        if minutes + hours * 60 > 60 &&  minutes + hours * 60 < 100 * 60{
            let durationSec = calculateDurationSec(duration: durationString)
            self.durationString = String(format: "%02d", durationSec / (60 * 60)) + ":" + String(format: "%02d", (durationSec % 3600) / 60)
        }
        return
    }

    func initSessionDuration() {
        let storedDuration = getSessionDuration()
        if storedDuration != 0 {
            self.durationString = String(format: "%02d", storedDuration / (60 * 60)) + ":" + String(format: "%02d", (storedDuration % 3600) / 60)
        }
        else {
            setSessionDuration(duration: 25 * 60)
            self.durationString = "00:25"
        }
    }

    func cancelEditButtonPressed() {
        self.durationString = self.oldDurationString
        self.editDurationMode = false
    }

    func saveEditButtonPressed() {
        let durationSec = calculateDurationSec(duration: durationString)
        self.editDurationMode = false
        setSessionDuration(duration: durationSec)
        refactorDurationString()
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

                        Rectangle().frame(width: geo.size.width, height: s.home.setDurationButtonHeight + s.home.setDurationLabelHeight + s.home.setDurationButtonPaddingTop + s.home.setDurationLabelPaddingTop).foregroundColor(.clear)
                    }

                    Button(action: {
                        self.startFocusPressed()
                    }) {
                        HStack(alignment: .center) {
                            Text("Start Focus").font(.system(size: 45, weight: .bold, design: .default)).kerning(-1).minimumScaleFactor(0.7).lineLimit(1)
                                .foregroundColor(Color.tan)
                            Spacer()
                            Image("rightArrow").resizable().frame(width: 52.25, height: 25, alignment: .center)
                        }.frame(width: geo.size.width * 0.9, height: .none, alignment: .leading)
                    }
                    .padding(.top, 50)
                    Button(action: {
                        self.setScreen("SelectApps")
                    }) {
                        HStack(alignment: .center) {
                            Text("Select Apps").font(.system(size: 45, weight: .regular, design: .default)).kerning(-1).minimumScaleFactor(0.7).lineLimit(1).foregroundColor(Color.tan)
                            Spacer()
                            Image("rightArrow-thin").resizable().frame(width: 52.25, height: 25, alignment: .center)
                        }.frame(width: geo.size.width * 0.90, height: .none, alignment: .leading)
                    }.padding(.top, 10)
                    Spacer()
                }
                .padding(.horizontal, 25).frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .offset(x: self.editDurationMode ? -1 * (geo.size.width + s.universal.horizontalPadding) : 0)
                VStack(spacing: 0) {
                        HStack{
                            Text("Set Focus Duration").kerning(-0.65).font(.system(size: 25, weight: self.editDurationMode ? .bold : .medium, design: .default)).foregroundColor(Color.tan)
                                .frame(height: s.home.setDurationLabelHeight)
                                .padding(.top, self.editDurationMode ? 0 : s.home.setDurationLabelPaddingTop)
                            Spacer()
                        }
                        SetDurationButton(durationString: self.$durationString, editDurationMode: self.$editDurationMode){
                            if !self.editDurationMode {
                                self.editDurationMode = true
                                print("in switch to edit. self.durationString: \(self.durationString)")
                                self.oldDurationString = self.durationString
                            }
                        }    .frame(width: self.editDurationMode ? geo.size.width : geo.size.width * 0.75)
                        .padding(.top, s.home.setDurationButtonPaddingTop)
                    if self.currentScreen == "HomeMenu"{
                    HStack(spacing: 0) {
                        Button(action: self.cancelEditButtonPressed) {
                            Text("Cancel").font(.system(size: 20, weight: .semibold, design: .default)).foregroundColor(Color.lightPurple)
                        }
                        .frame(width: (geo.size.width - s.home.setDurationEditorButtonsHSpace) / 2, height: 50).background(Image("bg-blur").resizable()).cornerRadius(7.0)
                        /*10 to correct unwanted edges with paralax*/
                        .offset(x: self.editDurationMode ? 0 : -1 * (10 + s.universal.horizontalPadding + (geo.size.width - s.home.setDurationEditorButtonsHSpace) / 2))

                        Rectangle().frame(width: s.home.setDurationEditorButtonsHSpace, height: 50).foregroundColor(Color.clear)
                        Button(action: self.saveEditButtonPressed) {
                            Text("Save").font(.system(size: 20, weight: .bold, design: .default)).foregroundColor(Color.lightPurple)
                        }.disabled(!self.validInput)
                        .frame(width: (geo.size.width - s.home.setDurationEditorButtonsHSpace) / 2, height: 50).background(Image("bg-blur").resizable()).cornerRadius(7.0)
                        /*10 to correct unwanted edges with paralax*/
                        .offset(x: self.editDurationMode ? 0 : (10 + s.universal.horizontalPadding + (geo.size.width - s.home.setDurationEditorButtonsHSpace) / 2))
                        .opacity(self.validInput ? 1.0 : 0.7)
                    }.padding(.top, 10)}
                    Spacer()
                }.offset(y: self.editDurationMode ? s.home.setDurationEditorPaddingTop : setDurationButtonTopPadding)
            }
        }.onAppear{
            self.initSessionDuration()
        }.animation(.spring())
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
    @State static var cScreen = "HomeMenu"
    static var previews: some View {
        Group {
            HomeMenu(currentScreen: self.$cScreen) { _ in
            } startFocusPressed: {}.padding(.horizontal, s.universal.horizontalPadding).background(Image("bg-grain").resizable().edgesIgnoringSafeArea(.all))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
        }
    }
}
