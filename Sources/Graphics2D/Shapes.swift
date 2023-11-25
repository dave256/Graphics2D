//
//  Shapes.swift
//
//
//  Created by David Reed on 11/24/23.
//

import SwiftUI
import Parsing

public enum UnitSquare: PathDrawableConvertible {
    public static var path: Path {
        Path { path in
            path.move(to: CGPoint(x: -0.5, y: -0.5))
            path.addLine(to: CGPoint(x: -0.5, y: 0.5))
            path.addLine(to: CGPoint(x: 0.5, y: 0.5))
            path.addLine(to: CGPoint(x: 0.5, y: -0.5))
            path.addLine(to: CGPoint(x: -0.5, y: -0.5))
        }
    }

    public static let parser = Parse(input: Substring.self) {
        "unit square"
        Whitespace(1, .vertical)
        DrawStyle.parser
        Whitespace(0..., .vertical)
        Transform.zeroOrMoreParser
    }.map { pathDrawable(path: path, drawStyle: $0, transforms: $1) }
}

public enum UnitCircle: PathDrawableConvertible {
    public static var path: Path {
        Path.init(ellipseIn: CGRect(x: -1.0, y: -1.0, width: 2.0, height: 2.0))
    }

    public static let parser = Parse(input: Substring.self) {
        "unit circle"
        Whitespace(1, .vertical)
        DrawStyle.parser
        Whitespace(0..., .vertical)
        Transform.zeroOrMoreParser
    }.map { pathDrawable(path: path, drawStyle: $0, transforms: $1) }
}

enum ShapeParser {
    static var parser = Parse(input: Substring.self) {
        OneOf {
            UnitSquare.parser
            UnitCircle.parser
        }
    }

    static var zeroOrMoreParser =  Parse(input: Substring.self) {
        Many {
            parser
        } separator: {
            Whitespace(0..., .vertical)
        }
    }
}
