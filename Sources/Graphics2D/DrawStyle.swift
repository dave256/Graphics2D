//
//  DrawStyle.swift
//  
//
//  Created by David Reed on 11/25/23.
//

import SwiftUI
import Parsing

public struct DrawStyle: Equatable {
    /// how to draw the shape (line for Polyline does not close the loop, shape is outline, and filled draws it filled)
    /// automatic parser generation since enum conforms to String, CaseIterable, and Equatable
    public enum Style: String, CaseIterable, Equatable {
        case path
        case closed
        case filled
    }

    /// enumerated type for a number of the SwiftUI Color values
    /// automatic parser generation since enum conforms to String, CaseIterable, and Equatable
    public enum Color: String, CaseIterable, Equatable {
        case black
        case blue
        case brown
        case clear
        case cyan
        case gray
        case green
        case indigo
        case mint
        case orange
        case pink
        case purple
        case red
        case teal
        case white
        case yellow

        var color: SwiftUI.Color {
            switch self {
                case .black:
                    return .black
                case .blue:
                    return .blue
                case .brown:
                    return .brown
                case .clear:
                    return .clear
                case .cyan:
                    return .cyan
                case .gray:
                    return .gray
                case .green:
                    return .green
                case .indigo:
                    return .indigo
                case .mint:
                    return .mint
                case .orange:
                    return .orange
                case .pink:
                    return .pink
                case .purple:
                    return .purple
                case .red:
                    return .red
                case .teal:
                    return .teal
                case .white:
                    return .white
                case .yellow:
                    return .yellow
            }
        }
    }

    var style: Style
    var color: Color
}

public extension DrawStyle {
    /// "path",, "closed", or "filled" followed by one or more spaces/tabs followed by a color
    static let parser = ParsePrint(input: Substring.self, .memberwise(DrawStyle.init)) {
        Style.parser()
        Whitespace(1..., .horizontal)
        Color.parser()
    }
}
