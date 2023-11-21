//
//  Parsing.swift
//
//
//  Created by David Reed on 11/19/23.
//

import CoreGraphics
import Parsing


// MARK: CGPoint
public extension CGPoint {

    /// two numbers (can be int or double) separated by one or more spaces
    static var parser = ParsePrint(input: Substring.self, .memberwise(CGPoint.init(x:y:))) {
        Double.parser()
        Whitespace(1..., .horizontal)
        Double.parser()
    }

    /// array of CGPoint - each point on its own line
    static var oneOrMoreParser = ParsePrint(input: Substring.self) {
        Many(1...) {
            CGPoint.parser
        } separator: {
            // each point must be on its own line
            "\n"
        } terminator: {
            // must have a \n after last point
            "\n".utf8
        }
    }
}

// attempt at making a protocol for this - didn't work - may revisit later
//protocol Parsable {
//    static var parser: any Parser<Substring, Self> { get }
//}
//
//extension CGPoint: Parsable {
//        static var parser: any Parsing.Parser<Substring, CGPoint> {
//            ParsePrint(input: Substring.self, .memberwise(CGPoint.init(x:y:))) {
//                Double.parser()
//                Whitespace(1..., .horizontal)
//                Double.parser()
//            }
//        }
//}
