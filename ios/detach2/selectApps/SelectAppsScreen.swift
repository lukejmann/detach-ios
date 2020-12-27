import SwiftUI
struct SelectAppsScreen: View {
    @State var apps: [SelectableApp] = []

    @Binding var swipeState: CGSize
    var setSwipeState: (_ state: CGSize) -> Void

    var setScreen: (_ screen: String) -> Void
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Select Apps")
                        .font(.system(size: 25, weight: .bold, design: .default))
                        .padding(.top, 30).foregroundColor(.tan)
                    Text("Select which apps are blocked during a session.")
                        .font(.system(size: 14, weight: .regular, design: .default)).padding(.top, 10).foregroundColor(.tan)
                }
                Rectangle()
                    .border(Color.black, width: 2)
                    .frame(width: 0, height: 38, alignment: .leading)
                    .foregroundColor(Color(hue: 0, saturation: 0, brightness: 0, opacity: 0))
                ScrollView {
                    ForEach(self.apps.sorted(by: { (app1, app2) -> Bool in
                        if app1.selected, !app2.selected {
                            return true
                        }
                        if app2.selected, !app1.selected {
                            return false
                        }
                        return app1.app.Name < app2.app.Name

                    })) { sApp in
                            AppRow(app: sApp).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0)).padding(.vertical, 5)
                    }
                    Rectangle().frame(width: 0, height: 50, alignment: .center)
                }.clipped()
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center).gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged { value in
                if value.translation.width > 0 {
                    self.setSwipeState(value.translation)
                }
            }.onEnded { _ in
                if self.swipeState.width > 100 {
                    self.setScreen("HomeMenu")
                }
                self.swipeState = .zero
            }).offset(x: 30 + swipeState.width, y: 25)
        }.animation(.easeIn).onAppear{
            self.apps = getSupportedApps().map { (app) -> SelectableApp in
                SelectableApp(app: app, selected: getSelectedAppNames().contains(app.Name.lowercased()))
            }
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
            print("[SELECT_APPS] app \(app.Name) toggled to \(selected)")
            let oldSelectedApps = getSelectedAppNames()
            if selected {
//                var done = false
//                oldSelectedApps.forEach { appName in
//                    if appName == app.Name.lowercased() {
//                        done = true
//                    }
//                }
//                if !done {
                    setSelectedAppNames(appNames: oldSelectedApps + [app.Name.lowercased()])
//                }
            } else {
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
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            RowButton(app: app)
            Text("\(app.app.Name.uppercased())").foregroundColor(app.selected ? Color.tan : Color.darkBlue).font(.system(size: 16, weight: .regular, design: .default))
        }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).onTapGesture {
            self.app.toggle()
        }
    }
}

struct SelectAppsScreen_Previews: PreviewProvider {
    @State static var swipeState = CGSize.zero
    static var previews: some View {
        SelectAppsScreen(swipeState: self.$swipeState, setSwipeState: { s in
            self.swipeState = s
        }, setScreen: { _ in
            //
        }).background(Image("bg-grain").resizable())
    }
}
