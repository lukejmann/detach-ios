//
// import Foundation
//// import UIKit
// import SwiftUI
//
// public struct DIImage: View {
//    var isLight: Bool = true
//    var imageName: String
//
//    @Environment(\.colorScheme) var colorScheme
//
//    public init(_ imageName: String) {
//        self.imageName = imageName
//    }
//
//    public init(_ imageName: String, isLight: Bool) {
//        self.imageName = imageName
//        self.isLight = isLight
//    }
//
//    func uiImage(light: Bool) -> UIImage? {
//        let image = UIImage(named: imageName)
//        if isLight == light {
//            return image!
//        }
//
//        return image?.invert() ?? nil
//    }
//
//    public var body: some View {
//        Image(uiImage: uiImage(light: colorScheme == ColorScheme.light)!).resizable()
//    }
// }
//
//
// extension UIImage {
//
// }
