//
//  Transform.swift
//
//
//  Created by David Reed on 11/19/23.
//

import CoreGraphics
import Parsing

/// a 2D rotation, scale, or translation transformation
public enum Transform: Equatable {
    // rotation angle in degrees
    case r(Double)
    // scale x and scale y
    case s(Double, Double)
    // translate x and translate y
    case t(Double, Double)
}

public extension [Transform] {
    /// apply the transformations in the order they are in the array
    var combined: CGAffineTransform {
        var result = CGAffineTransform.identity
        for tfm in self {
            switch tfm {
                case let .r(degrees):
                    result = result.concatenating(.init(rotationAngle: degrees * Double.pi / 180.0))

                case let .s(sx, sy):
                    result = result.concatenating(.init(scaleX: sx, y: sy))

                case let .t(tx, ty):
                    result = result.concatenating(.init(translationX: tx, y: ty))
            }
        }
        return result
    }
}

public protocol Transformable {
    var transforms: [Transform] { get }
}

public extension Transformable {
    /// default computed property  for any Transformable type that combines all the transformations in the transforms array in the array order
    var transform: CGAffineTransform {
        transforms.combined
    }
}

public extension Transform {

    // a transform is one of the rotate, scale, or translate transformation
    static var parser = ParsePrint(input: Substring.self) {
        OneOf {
            rotateParsePrint
            scaleParsePrint
            translateParsePrint
        }
    }

    /// zero or more transformations separated by at least one white space character (prints a newline between them)
    /// won't consume whitespace if there are no transforms
    static var zeroOrMoreParser = ParsePrint(input: Substring.self) {
        OneOf {
            ParsePrint {
                // first try to handle any white space before it and consume it
                Whitespace(0..., .vertical).printing("".utf8)
                // next look for one more more transforms separated by a newline
                Many(1...) {
                    Transform.parser
                } separator: {
                    "\n".utf8
                }
            }
            // if no transforms, this will leave the white space since we only consume it if there is at least one transform
            // this is necessary so we don't need two blank lines when there are no transforms
            "".map { [Transform]() }
        }
    }

    /// r followed by one or more spaces/tabs, followed by the angle in degrees
    static var rotateParsePrint = ParsePrint(input: Substring.self, RotateConversion()) {
        "r"
        Whitespace(1..., .horizontal)
        Double.parser()
    }

    /// s followed by one ore more spaces followed by a number for the x scale, followed by one ore more spaces followed by the number for the y scale
    static var scaleParsePrint = ParsePrint(input: Substring.self, ScaleConversion()) {
        "s"
        Whitespace(1..., .horizontal)
        Double.parser()
        Whitespace(1..., .horizontal)
        Double.parser()
    }

    /// t followed by one ore more spaces followed by a number for the x translation, followed by one ore more spaces followed by the number for the y translation
    static var translateParsePrint = ParsePrint(input: Substring.self, TranslateConversion()) {
        "t"
        Whitespace(1..., .horizontal)
        Double.parser()
        Whitespace(1..., .horizontal)
        Double.parser()
    }

    /// Conversion necessary for parsing
    struct RotateConversion: Conversion {
        public func apply(_ angle: Double) -> Transform {
            // make a Transform from the angle
            Transform.r(angle)
        }

        public func unapply(_ transform: Transform) throws -> Double {
            struct ParseError: Error {}
            switch transform {
                    // handle the rotation case
                case let .r(angle):
                    return angle
                default:
                    // throw an error for all other types for correct parsing/printing
                    throw ParseError()
            }
        }
    }

    /// Conversion necessary for parsing
    struct ScaleConversion: Conversion {
        public func apply(_ scales: (Double, Double)) -> Transform {
            // make a Transform with the scale values
            Transform.s(scales.0, scales.1)
        }

        public func unapply(_ transform: Transform) throws -> (Double, Double) {
            struct ParseError: Error {}
            switch transform {
                    // handle the scale case
                case let .s(sx, sy):
                    return (sx, sy)
                default:
                    // throw an error for all other types for correct parsing/printing
                    throw ParseError()
            }
        }
    }

    /// Conversion necessary for parsing
    struct TranslateConversion: Conversion {
        public func apply(_ translates: (Double, Double)) -> Transform {
            // make a Transform with the translation values
            Transform.t(translates.0, translates.1)
        }

        public func unapply(_ transform: Transform) throws -> (Double, Double) {
            struct ParseError: Error {}
            switch transform {
                    // handle the translation case case
                case let .t(tx, ty):
                    return (tx, ty)
                default:
                    // throw an error for all other types for correct parsing/printing
                    throw ParseError()
            }
        }
    }
}

