import CoreGraphics
import Graphics2D

var s: Substring = "2 3"
var pt = try CGPoint.parser.parse(s)
print(pt)

s = "2.5 3.0\n4.0 5.5\n"
var pts = try CGPoint.oneOrMoreParser.parse(s)
print(pts)
var output: Substring = ""
try CGPoint.oneOrMoreParser.print(pts, into: &output)
s == output

