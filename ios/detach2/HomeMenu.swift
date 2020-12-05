//
//  HomeMenu.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct HomeMenu: View {
//    @Binding var hasDetachPlus: Bool
    var setScreen: (_ screen: String) -> Void

    var canStartSession: Bool {
        true
        //        print("getTrialSession()?.date: \(getTrialSession()?.date)")
        //        let trialS = getTrialSession()
        //        if trialS != nil {
        //            return self.hasDetachPlus || !trialS!.date.isToday()
        //        }
        //        return true
    }

    var showDurationScreen: () -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Text("detach").font(.custom("Georgia-Italic", size: 42)).foregroundColor(Color.tan)
                    }.frame(width: geo.size.width, height: .none, alignment: .center).padding(.top, 65)
                    Text("Set Focus Duration").kerning(-0.65).font(.system(size: 25, weight: .light, design: .default)).padding(.top, 65).foregroundColor(Color.tan).padding(.horizontal, 25)
                    SetDurationButton {
                        self.showDurationScreen()
                    }.padding(.top, 30)
                    Button(action: {
                        self.setScreen("start")
                    }) {
                            HStack(alignment: .center) {
                                Text("Start Focus").font(.system(size: 45, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.tan).padding(.horizontal, 25)
                                Image("rightArrow").resizable().frame(width: 52.25, height: 25, alignment: .center)
                            }.frame(width: 0.82 * geo.size.width, height: .none, alignment: .leading)
                    }.padding(.top, 40)
                    Button(action: {
                        self.setScreen("SelectApps")
                    }) {
                            HStack(alignment: .center) {
                                Text("Select Apps").font(.system(size: 45, weight: .bold, design: .default)).kerning(-1).foregroundColor(Color.tan).padding(.horizontal, 25)
                                Image("rightArrow").resizable().frame(width: 52.25, height: 25, alignment: .center)
                            }.frame(width: 0.85 * geo.size.width, height: .none, alignment: .leading)
                    }.padding(.top, 20)

                    Spacer()
                }.padding(.horizontal, 25).padding(.top, 15).frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
        }
    }
}

struct SetDurationButton: View {
    @Environment(\.colorScheme) var colorScheme

    var showSetDuration: () -> Void

    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    showSetDuration()
                }) {
                        VStack(alignment: .center) {
                            Text("01:20").font(.newYorkXL(size: 60.0)).foregroundColor(Color.darkBlue)
                            HStack(alignment: .center, spacing: 0) {
                                Spacer()
                                Rectangle().fill(Color.darkBlue).frame(width: 200, height: 1, alignment: .center)
                                Spacer()
                            }.padding(.top, 1)
                            HStack(alignment: .center, spacing: 0) {
                                Spacer()
                                Text("HOURS")
                                Spacer().frame(width: 31, height: 0, alignment: .center)
                                Text("MINUTES")
                                Spacer()
                            }.foregroundColor(Color.darkBlue)
                        }
                }
                .frame(width: geometry.size.width * 0.6, height: 154).background(Color.tan).cornerRadius(15.0)
                Spacer()
            }
        }.frame(height: 154)
    }
}

struct HomeMenu_Previews: PreviewProvider {
    @State static var hasDetachPlus = false

    static var previews: some View {
        Group {
            HomeMenu {
                _ in
            } showDurationScreen: {}.background(Image("bg-grain"))
                .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
                .previewDisplayName("iPhone 11")
//      r
        }
    }
}

extension Date {
    func isToday() -> Bool {
        Calendar.current.isDateInToday(self)
    }
}

//
// struct CornerRadiusStyle: ViewModifier {
//    var radius: CGFloat
//    var corners: UIRectCorner
//
//    struct CornerRadiusShape: Shape {
//
//        var radius = CGFloat.infinity
//        var corners = UIRectCorner.allCorners
//
//        func path(in rect: CGRect) -> Path {
//            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//            return Path(path.cgPath)
//        }
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
//    }
// }

// extension View {
//    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
//        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
//    }
// }
