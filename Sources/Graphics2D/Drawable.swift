//
//  Drawable.swift
//
//
//  Created by David Reed on 11/24/23.
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
    /// line, shape, or fill followed by one or more spaces/tabs followed by a color
    static let parser = ParsePrint(input: Substring.self, .memberwise(DrawStyle.init)) {
        Style.parser()
        Whitespace(1..., .horizontal)
        Color.parser()
    }
}

public protocol Drawable {
    func draw(context: GraphicsContext)
}

public struct PathDrawable: Drawable, Transformable, Equatable {
    public init(path: Path, drawStyle: DrawStyle, transforms: [Transform]) {
        self.path = path
        self.drawStyle = drawStyle
        self.transforms = transforms
        self.transform = transforms.combined
    }

    /// path for the shape that is drawn
    public let path: Path

    /// how to draw: (line option for Polyline, or shape, or filled) and the color to use
    public let drawStyle: DrawStyle
    public var transforms: [Transform] {
        // make certain the transform property stays updated when transforms change
        didSet {
            transform = transforms.combined
        }
    }
    /// composite transform applied to the shape
    public private(set) var transform: CGAffineTransform

    public func draw(context: GraphicsContext) {
        let transform = transforms.combined.concatenating(context.transform)
        let tfm = transform.concatenating(context.transform)
        // transform the path otherwise the lineWidth is also scaled
        let p = path.transform(tfm).path(in: .infinite)
        // get a copy so we can mutate it
        var context = context
        // set context's transform to identity since we transformed the path
        context.transform = .identity

        switch drawStyle.style {
        case .path:
            // draw outline
            context.stroke(p, with: .color(drawStyle.color.color))
        case .closed:
            var p = p
            // close path and draw outline
            p.closeSubpath()
            context.stroke(p, with: .color(drawStyle.color.color))
        case .filled:
            // draw filled shape
            context.fill(p, with: .color(drawStyle.color.color))
        }
    }

}

public protocol PathDrawableConvertible {
    static func pathDrawable(path: Path, drawStyle: DrawStyle, transforms: [Transform]) -> PathDrawable
}

extension PathDrawableConvertible {
    public static func pathDrawable(path: Path, drawStyle: DrawStyle, transforms: [Transform]) -> PathDrawable {
        PathDrawable(path: path, drawStyle: drawStyle, transforms: transforms)
    }
}


//public protocol PathDrawable: Drawable {
//    var path: Path { get }
//    var drawStyle: DrawStyle { get }
//    var transforms: [Transform] { get }
//}

