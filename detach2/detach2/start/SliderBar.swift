//
//  SliderBar.swift
//  detach2
//
//  Created by Luke Mann on 8/12/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI

struct SliderBar: View {
    @Binding var percentage: Float
    var lastPercent = 0

    @Binding var distance: CGFloat
    @Binding var mode: StartMode

    var showKeyboard: () -> Void
    var hideKeyboard: () -> Void

    var thresholdReached: () -> Void

    func barColor(mode: StartMode) -> Color {
        switch mode {
        case .proxyEnabled:
            return Color.sliderGreen
        case .validInput:
            return Color(red: 247 / 255, green: 255 / 255, blue: 182 / 255)
        default:
            return Color.gray
        }
    }

    var body: some View {
        GeometryReader { geometry in
            // TODO: - there might be a need for horizontal and vertical alignments
            ZStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .foregroundColor(self.barColor(mode: self.mode))
                    Text("BEGIN SESSION").font(.system(size: 14, weight: .medium, design: .default))
                }

                Rectangle()
                    .foregroundColor(.black)
                    .frame(width: self.distance).border(Color.white)
                Image("slider").resizable().frame(width: 55, height: 55, alignment: .leading).padding(.leading, CGFloat(self.distance)).gesture(DragGesture(minimumDistance: 0).onEnded { _ in
                    self.distance = 0
                    self.showKeyboard()
                }
                .onChanged { value in
                    if self.mode == .disabled {
                        return
                    }
                    let xDist = value.location.x
                    if !(xDist > geometry.size.width - 55 || xDist < 0) {
                        self.distance = value.location.x
                        self.percentage = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
//                        print("percent: \(self.percentage)")
                        if self.percentage > 75 {
//                            print("reached 75!")
                            self.hideKeyboard()
                            self.thresholdReached()
                        }
                        self.percentage = Float(self.lastPercent)
                    }
                })
            }.frame(width: nil, height: 55, alignment: .leading)
                .border(Color.black)
        }.frame(width: nil, height: 55, alignment: .leading).padding(.top, 42)
    }
}

struct SliderBar_Previews: PreviewProvider {
    static var previews: some View {
      Text("N/A")
    }
}
