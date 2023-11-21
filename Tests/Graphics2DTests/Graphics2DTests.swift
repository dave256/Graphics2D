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
