import SwiftUI

struct SelectAppsScreen: View {
    @State var apps: [SelectableApp] = getSupportedApps().map { (app) -> SelectableApp in
        SelectableApp(app: app, selected: getSelectedAppNames().contains(app.Name.lowercased()))
    }

    var setScreen: (_ screen: String) -> Void

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: {
                        self.setScreen("HomeMenu")
                    }) {
                            Image("leftArrow").resizable().frame(width: 44, height: 21, alignment: .leading)
                    }
                    Text("Select Apps")
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .padding(.top, 30).foregroundColor(.tan)
                    Text("Select which apps are blocked during a session.")
                        .font(.system(size: 14, weight: .regular, design: .default)).padding(.top, 10).foregroundColor(.tan)
                }.padding(.horizontal, 37)
                Rectangle()
                    .border(Color.black, width: 2)
                    .frame(width: 0, height: 38, alignment: .leading)
                    .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0, opacity: 0))
                ScrollView {
                    ForEach(self.apps) { sApp in
                        AppRow(app: sApp).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)).padding(.horizontal, 37).padding(.vertical, 5)
                    }
                    Rectangle().frame(width: 0, height: 50, alignment: .center)
                }.clipped()
            }.padding(.top, 60).frame(width: nil, height: geo.size.height, alignment: .center)
        }
    }
}

struct RowButton: View {
    var app: SelectableApp

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .border(app.selected ? Color.tan : Color.black, width: 1.6)
                .animation(.easeIn(duration: 0.15))
                .frame(width: 20, height: 20, alignment: .leading)
                .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0, opacity: 0))
            Rectangle()
                .frame(width: 8, height: 8, alignment: .leading).foregroundColor(app.selected ? Color.tan : Color(.displayP3, white: 0.0, opacity: 0.0)).animation(.easeIn(duration: 0.15))
        }
    }
}

struct SelectableApp: Identifiable {
    public let id = UUID()
    var app: App

    @Environment(\.colorScheme) var colorScheme

    var selected: Bool {
        didSet {
            print("app \(app.Name) toggled to \(selected)")
            let oldSelectedApps = getSelectedAppNames()
            if selected {
                // check if already there. if it is do nothing. if not add
                var done = false
                oldSelectedApps.forEach { appName in
                    if appName == app.Name.lowercased() {
                        done = true
                    }
                }
                if !done {
                    setSelectedAppNames(appNames: oldSelectedApps + [app.Name.lowercased()])
                }
            } else {
                // filter appname from list
                setSelectedAppNames(appNames: oldSelectedApps.filter { $0 != app.Name.lowercased() })
            }
        }
    }

    mutating func toggle() {
        selected = !selected
    }
}

struct AppRow: View {
    @State var app: SelectableApp

//    let hPadding = CGFloat(37-10)
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            RowButton(app: app)
            Text("\(app.app.Name.uppercased())").foregroundColor(self.colorScheme == .dark ? Color.white : Color.black).font(.system(size: 16, weight: .regular, design: .default))
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).onTapGesture {
            self.app.toggle()
        }
    }
}

struct SelectAppsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectAppsScreen {
            _ in
        }.background(Image("bg-grain"))
            .previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
            .previewDisplayName("iPhone 11 Pro")
    }
}
