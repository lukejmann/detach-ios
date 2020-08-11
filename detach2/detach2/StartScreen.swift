//
//  StartScreen.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct StartScreen: View {
    var setScreen: (_ screen:String)->Void
    @State var sliderPercent: Float = 20
    @State var sliderMode: SliderMode = .proxyDisabled
    
    
    init(setScreen: @escaping (_ screen:String)->Void) {
        self.setScreen = setScreen
    }
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0){
                Image("back").resizable().frame(width: 9, height: 17, alignment: .leading).onTapGesture {
                    self.setScreen("HomeMenu")
                }
                Text("begin blocking session").font(.custom("Georgia-Italic", size: 25)).padding(.top,50)
                Text("SET HOW LONG THE SELECTED APPS WILL BE BLOCKED FOR").font(.system(size: 14, weight: .regular, design: .default)).padding(.top,10)
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text("00:00").font(.custom("NewYorkLarge-SemiboldItalic", size: 70)).padding(.top,50)
                    Spacer()
                }
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Rectangle().fill(Color.gray).frame(width: 200, height: 1, alignment: .center)
                    Spacer()
                }.padding(.top,8)
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text("HOURS")
                    Spacer().frame(width: 31, height: 0, alignment: .center)
                    Text("MINUTES")
                    Spacer()
                }.padding(.top,8)
                SliderBar(percentage: self.$sliderPercent, mode: self.$sliderMode)
                
            }.padding(.top, 58.0).padding(.horizontal,37)
                .frame(width: geometry.size.width,
                       height: geometry.size.height,
                       alignment: .topLeading)
            
        }
    }
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen { (s) in
            //
        }
    }
}

enum SliderMode {
    case disabled
    case proxyDisabled
    case enabled
}


struct SliderBar: View {
    
    @Binding var percentage: Float
    @State var distance: CGFloat = 0
    @Binding var mode: SliderMode
    
    func barColor(mode: SliderMode) -> Color {
        switch mode {
        case .enabled:
            return Color.green
        case .proxyDisabled:
//            return Color.blue
            return Color(red: 247/255, green: 255/255, blue: 182/255)
        default:
            return Color.gray
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                ZStack{
                    Rectangle()
                               .foregroundColor(self.barColor(mode: self.mode))
                    Text("BEGIN SESSION").font(.system(size: 14, weight: .medium, design: .default))
                }
       
                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: self.distance)
                Image("slider").resizable().frame(width: 55, height: 55, alignment: .leading).padding(.leading,CGFloat(self.distance))
                
            }.frame(width: nil, height: 55, alignment: .leading)
                .gesture(DragGesture(minimumDistance: 0)
                    .onChanged({ value in
                        let xDist = value.location.x
                        if !(xDist>geometry.size.width-55 || xDist<0){
                            self.distance = value.location.x
                              self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                        }
                    })).border(Color.black)
        }.frame(width: nil, height: 55, alignment: .leading).padding(.top,83)
    }
}
