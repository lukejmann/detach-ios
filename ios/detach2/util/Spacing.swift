//
//  Spacing.swift
//  detach2
//
//  Created by Luke Mann on 12/26/20.
//  Copyright © 2020 Luke Mann. All rights reserved.
//

import Foundation
import SwiftUI

public struct DSpacing {
    var universal: DUniversalSpacing
    var home: DHomeSpacing
}

public struct DUniversalSpacing {
    var horizontalPadding: CGFloat
    var statusIndicatorToTop: CGFloat
}

public struct DHomeSpacing {
    var detachTitleHeight: CGFloat
    var detachTitleToTop: CGFloat
    var detachTitleWidth: CGFloat
    var setDurationLabelHeight: CGFloat
    var setDurationLabelPaddingTop: CGFloat
    var setDurationButtonPaddingTop: CGFloat
    var setDurationButtonHeight: CGFloat
//    var setDurationLabelWidth: CGFloat
    var setDurationEditorPaddingTop: CGFloat
    var setDurationEditorButtonsHSpace: CGFloat
}

let s = DSpacing(
    universal: DUniversalSpacing(
        horizontalPadding: 30,
        statusIndicatorToTop: 30),
    home:
    DHomeSpacing(
        detachTitleHeight: 50,
        detachTitleToTop: 50,
        detachTitleWidth: 126,
        setDurationLabelHeight: 20,
        setDurationLabelPaddingTop: 35,
        setDurationButtonPaddingTop: 30,
        setDurationButtonHeight: 154,
//        setDurationLabelWidth: 250,
        setDurationEditorPaddingTop: 30,
        setDurationEditorButtonsHSpace: 14))
