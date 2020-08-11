//
//  ContentView.swift
//  detach2
//
//  Created by Luke Mann on 8/11/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @State public var cScreen: String = "HomeMenu"
    
    
    var body: some View {
        VStack{
            if cScreen=="HomeMenu"{
                HomeMenu { (screen) in
                    self.cScreen=screen
                }
            }
            else if cScreen=="Start"{
                StartScreen{ (screen) in
                    self.cScreen=screen
                }
            }
            else {
                Text("Unknown Screen"+self.cScreen)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
