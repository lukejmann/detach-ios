import SwiftUI

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension View {
    public func inject<SomeView>(_ view: SomeView) -> some View where SomeView: View {
        return overlay(view.frame(width: 0, height: 0))
    }
}

#if canImport(UIKit)
extension View {

    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: UIView>(
        selector: @escaping (IntrospectionUIView) -> TargetView?,
        customize: @escaping (TargetView) -> Void
    ) -> some View {
        return inject(UIKitIntrospectionView(
            selector: selector,
            customize: customize
        ))
    }

    /// Finds a `UINavigationController` from any view embedded in a `SwiftUI.NavigationView`.
    public func introspectNavigationController(customize: @escaping (UINavigationController) -> Void) -> some View {
        return inject(UIKitIntrospectionViewController(
            selector: { introspectionViewController in

                // Search in ancestors
                if let navigationController = introspectionViewController.navigationController {
                    return navigationController
                }

                // Search in siblings
                return Introspect.previousSibling(containing: UINavigationController.self, from: introspectionViewController)
            },
            customize: customize
        ))
    }

    /// Finds the containing `UIViewController` of a SwiftUI view.
    public func introspectViewController(customize: @escaping (UIViewController) -> Void) -> some View {
        return inject(UIKitIntrospectionViewController(
            selector: { $0.parent },
            customize: customize
        ))
    }

    /// Finds a `UITabBarController` from any SwiftUI view embedded in a `SwiftUI.TabView`
    public func introspectTabBarController(customize: @escaping (UITabBarController) -> Void) -> some View {
        return inject(UIKitIntrospectionViewController(
            selector: { introspectionViewController in

                // Search in ancestors
                if let navigationController = introspectionViewController.tabBarController {
                    return navigationController
                }

                // Search in siblings
                return Introspect.previousSibling(ofType: UITabBarController.self, from: introspectionViewController)
            },
            customize: customize
        ))
    }

    /// Finds a `UITableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (UITableView) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }

    /// Finds a `UIScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (UIScrollView) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }

    /// Finds a `UITextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (UITextField) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `UISwitch` from a `SwiftUI.Toggle`
    @available(tvOS, unavailable)
    public func introspectSwitch(customize: @escaping (UISwitch) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `UISlider` from a `SwiftUI.Slider`
    @available(tvOS, unavailable)
    public func introspectSlider(customize: @escaping (UISlider) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `UIStepper` from a `SwiftUI.Stepper`
    @available(tvOS, unavailable)
    public func introspectStepper(customize: @escaping (UIStepper) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `UIDatePicker` from a `SwiftUI.DatePicker`
    @available(tvOS, unavailable)
    public func introspectDatePicker(customize: @escaping (UIDatePicker) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `UISegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (UISegmentedControl) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
}
#endif

#if canImport(AppKit)
extension View {

    /// Finds a `TargetView` from a `SwiftUI.View`
    public func introspect<TargetView: NSView>(
        selector: @escaping (IntrospectionNSView) -> TargetView?,
        customize: @escaping (TargetView) -> Void
    ) -> some View {
        return inject(AppKitIntrospectionView(
            selector: selector,
            customize: customize
        ))
    }

    /// Finds a `NSTableView` from a `SwiftUI.List`, or `SwiftUI.List` child.
    public func introspectTableView(customize: @escaping (NSTableView) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }

    /// Finds a `NSScrollView` from a `SwiftUI.ScrollView`, or `SwiftUI.ScrollView` child.
    public func introspectScrollView(customize: @escaping (NSScrollView) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.ancestorOrSibling, customize: customize)
    }

    /// Finds a `NSTextField` from a `SwiftUI.TextField`
    public func introspectTextField(customize: @escaping (NSTextField) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `NSSlider` from a `SwiftUI.Slider`
    public func introspectSlider(customize: @escaping (NSSlider) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `NSStepper` from a `SwiftUI.Stepper`
    public func introspectStepper(customize: @escaping (NSStepper) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `NSDatePicker` from a `SwiftUI.DatePicker`
    public func introspectDatePicker(customize: @escaping (NSDatePicker) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }

    /// Finds a `NSSegmentedControl` from a `SwiftUI.Picker` with style `SegmentedPickerStyle`
    public func introspectSegmentedControl(customize: @escaping (NSSegmentedControl) -> Void) -> some View {
        return introspect(selector: TargetViewSelector.sibling, customize: customize)
    }
}
#endif
