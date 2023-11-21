import XCTest
@testable import Graphics2D

final class Graphics2DTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
}

final class CGPointParsingTests: XCTestCase {
    func testParsePoint() throws {
        let input: Substring = "2.75 3.5"
        let p = try CGPoint.parser.parse(input)
        XCTAssertEqual(p, CGPoint(x: 2.75, y: 3.5))
    }

    func testPrintPoint() throws {
        let p = CGPoint(x: 2, y: 3)
        let output = try CGPoint.parser.print(p)
        XCTAssertEqual(output, "2.0 3.0")
    }

    func testParseArrayPoints() throws {
        let input: Substring = "2 3\n4 5\n"
        let pts = try CGPoint.oneOrMoreParser.parse(input)
        XCTAssertEqual(pts, [CGPoint(x: 2, y: 3), CGPoint(x: 4, y: 5)])
    }

    func testPrintArrayPoints() throws {
        let pts =  [CGPoint(x: 2, y: 3), CGPoint(x: 4, y: 5), CGPoint(x: 10.5, y: 11.5)]
        let output = try CGPoint.oneOrMoreParser.print(pts)
        XCTAssertEqual(output, "2.0 3.0\n4.0 5.0\n10.5 11.5\n")
    }
}

final class TransformParsingTests: XCTestCase {
    func testParseRotate() throws {
        let input: Substring = "r 45"
        let t = try Transform.parser.parse(input)
        XCTAssertEqual(t, Transform.r(45))
    }

    func testPrintRotate() throws {
        let t = Transform.r(45)
        let output = try Transform.parser.print(t)
        XCTAssertEqual(output, "r 45.0")
    }

    func testParseScale() throws {
        let input: Substring = "s 2.5 3.5"
        let t = try Transform.parser.parse(input)
        XCTAssertEqual(t, Transform.s(2.5, 3.5))
    }

    func testPrintScale() throws {
        let t = Transform.s(3.5, 2.5)
        let output = try Transform.parser.print(t)
        XCTAssertEqual(output, "s 3.5 2.5")
    }

    func testParseTranslate() throws {
        let input: Substring = "t 2.5 3.5"
        let t = try Transform.parser.parse(input)
        XCTAssertEqual(t, Transform.t(2.5, 3.5))
    }

    func testPrintTranslate() throws {
        let t = Transform.t(3.5, 2.5)
        let output = try Transform.parser.print(t)
        XCTAssertEqual(output, "t 3.5 2.5")
    }

    func testParseZeroTransform() throws {
        let input: Substring = ""
        let tfms = try Transform.zeroOrMoreParser.parse(input)
        XCTAssertEqual(tfms, [])
    }

    func testPrintZeroTransform() throws {
        let tfms: [Transform] = []
        let output = try Transform.zeroOrMoreParser.print(tfms)
        XCTAssertEqual(output, "")
    }

    func testParseThreeTransforms() throws {
        let input: Substring = """
        s 2.5 3.5
        r 45.5
        t 4.5 5.25
        """
        let tfms = try Transform.zeroOrMoreParser.parse(input)
        XCTAssertEqual(tfms, [.s(2.5, 3.5), .r(45.5), .t(4.5, 5.25)])
    }

    func testPrintThreeTransforms() throws {
        let expected: Substring = """
        s 2.5 3.5
        r 45.5
        t 4.5 5.25
        """
        let tfms: [Transform] = [.s(2.5, 3.5), .r(45.5), .t(4.5, 5.25)]
        let output = try Transform.zeroOrMoreParser.print(tfms)
        XCTAssertEqual(output, expected)
    }
}
