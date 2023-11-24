//
//  Shapes.swift
//
//
//  Created by David Reed on 11/24/23.
//

import SwiftUI
import Parsing

/// square with sides of  length one centered at  (0, 0)
public struct UnitSquare: PathDrawable, Equatable {
    /// init
    /// - Parameters:
    ///   - drawStyle: how to draw the shape
    ///   - transforms: transforms to apply to the shape in the order they are in the array
    public init(drawStyle: DrawStyle, transforms: [Transform]) {
        self.drawStyle = drawStyle
        self.transforms = transforms
    }

    public let drawStyle: DrawStyle
    public let transforms: [Transform]
    public var path: Path {
        Path { path in
            path.move(to: CGPoint(x: -0.5, y: -0.5))
            path.addLine(to: CGPoint(x: -0.5, y: 0.5))
            path.addLine(to: CGPoint(x: 0.5, y: 0.5))
            path.addLine(to: CGPoint(x: 0.5, y: -0.5))
            path.addLine(to: CGPoint(x: -0.5, y: -0.5))
        }
    }
}

public extension UnitSquare {
    /// "unit square" followed by a blank line followed by a DrawStyle (such as "filled red") followed by a blank line followed by Transforms (such as "r 45.0" or "s 2.5 3.5" or "t 1.5 2.5")
    static let parser = ParsePrint(input: Substring.self, .memberwise(UnitSquare.init)) {
        "unit square"
        Whitespace(1, .vertical)
        DrawStyle.parser
        Whitespace(1, .vertical)
        Transform.zeroOrMoreParser
    }
}

/// circle with radius one centered at (0, 0)
/// note this will be larger than the unit square - for it to be similar, it would need to have radius 0.5
public struct UnitCircle: PathDrawable, Equatable {
    /// init
    /// - Parameters:
    ///   - drawStyle: how to draw the shape
    ///   - transforms: transforms to apply to the shape in the order they are in the array
    public init(drawStyle: DrawStyle, transforms: [Transform]) {
        self.drawStyle = drawStyle
        self.transforms = transforms
    }

    public let drawStyle: DrawStyle
    public let transforms: [Transform]
    public var path: Path {
        Path.init(ellipseIn: CGRect(x: -1.0, y: -1.0, width: 2.0, height: 2.0))
    }

}

public extension UnitCircle {
    /// "unit circle" followed by a blank line followed by a DrawStyle (such as "filled red") followed by a blank line followed by Transforms (such as "r 45.0" or "s 2.5 3.5" or "t 1.5 2.5")
    static let parser = ParsePrint(input: Substring.self, .memberwise(UnitCircle.init)) {
        "unit circle"
        Whitespace(1, .vertical)
        DrawStyle.parser
        Whitespace(1, .vertical)
        Transform.zeroOrMoreParser
    }
}
