//
//  HomeMenu.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct HomeMenu: View {
    var setScreen: (_ screen: String) -> Void
    init(setScreen: @escaping (_ screen: String) -> Void) {
        self.setScreen = setScreen
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 95.0) {
                Text("detach").font(.custom("Georgia-Italic", size: 42)).padding(.top, 85)
                VStack(alignment: .leading, spacing: 95) {
//                NavigationLink(destination: StartView()){
                    HStack(alignment: .center, spacing: 28) {
                        Image("start").resizable().frame(width: 58, height: 58, alignment: .center)
                        VStack(alignment: .leading, spacing: -12) {
                            Text("START")
                            Text("BLOCKING")
                        }
                    }.onTapGesture {
                        self.setScreen("Start")
                    }

                    HStack(alignment: .center, spacing: 28) {
                        Image("select").resizable().frame(width: 50, height: 50, alignment: .center)
                        VStack(alignment: .leading, spacing: -12) {
                            Text("SELECT")
                            Text("APPS")
                        }
                    }
                    HStack(alignment: .center, spacing: 28) {
                        Image("plus").resizable().frame(width: 50, height: 50, alignment: .center)
                        VStack(alignment: .leading, spacing: -12) {
                            Text("DETACH")
                            Text("PLUS")
                        }
                    }
                }.font(.system(size: 40, weight: .medium, design: .default))
                Spacer()
            }.frame(
                width: geometry.size.width,
                height: geometry.size.height,
                alignment: .center)
        }
    }
}

struct HomeMenu_Previews: PreviewProvider {
    static var previews: some View {
        HomeMenu { _ in
        }
    }
}
