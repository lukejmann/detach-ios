import SwiftUI
struct HomeMenu: View {
    @Binding var durationString: String
    var setScreen: (_ screen: String) -> Void
    var startFocusPressed: () -> Void
    var showDurationScreen: () -> Void
    @Environment(\.colorScheme) var colorScheme


    func setDurationButtonTopPadding() {
        return s.home.detachTitleHeight + s.home.detachTitleToTop + s.home.setDurationLabelHeight + s.home.setDurationLabelPaddingTop + s.homeset.DurationButtonPaddingTop
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Text("detach").font(.custom("Georgia-Italic", size: 42)).foregroundColor(Color.tan)
                    }.frame(width: geo.size.width, height: s.home.detachTitleHeight, alignment: .center).padding(.top, s.home.detachTitleToTop)
                    Text("Set Focus Duration").kerning(-0.65).font(.system(size: 25, weight: .medium, design: .default)).foregroundColor(Color.tan).frame(height: s.home.setDurationLabelHeight).padding(.top, s.home.setDurationLabelPaddingTop)
                    Rectangle().frame(height: 154).padding(.top, s.home.setDurationButtonPaddingTop)
                    Button(action: {
                        self.startFocusPressed()
                    }) {
                            HStack(alignment: .center) {
                                Text("Start Focus").font(.system(size: 45, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.tan)
                                Spacer()
                                Image("rightArrow").resizable().frame(width: 52.25, height: 25, alignment: .center)
                            }.frame(width: geo.size.width * 0.9, height: .none, alignment: .leading)
                    }.padding(.top, 40)
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
                }.padding(.horizontal, 25).frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                VStack{
                    SetDurationButton(durationString: self.$durationString) {
                        self.showDurationScreen()
                    }.padding(.top, setDurationButtonTopPadding())
                    Spacer()
                }
            }
        }
    }
}

struct SetDurationButton: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var durationString: String
    var showSetDuration: () -> Void
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    showSetDuration()
                }) {
                        VStack(alignment: .center, spacing: 0) {
                            Text(" " + self.durationString + " ").font(.newYorkXL(size: 60.0)).foregroundColor(Color.midPurple)
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
                }
                .frame(width: geometry.size.width * 0.75, height: 154).background(Image("bg-blur").resizable().edgesIgnoringSafeArea([.top,.bottom])).cornerRadius(15.0)
                Spacer()
            }
        }.frame(height: 154)
    }
}

struct HomeMenu_Previews: PreviewProvider {
    @State static var durationString = "04:20"
    static var previews: some View {
        Group {
            HomeMenu(durationString: self.$durationString) { _ in
            } startFocusPressed: {} showDurationScreen: {}.background(Image("bg-grain").resizable().edgesIgnoringSafeArea(.all))
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
//                .previewDisplayName("iPhone 11")
        }
    }
}
