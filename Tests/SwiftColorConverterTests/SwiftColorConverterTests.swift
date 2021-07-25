    import XCTest
    @testable import SwiftColorConverter

    final class SwiftColorConverterTests: XCTestCase {
        var sut: SwiftColorConverter!
        
        override func setUp() {
            sut = SwiftColorConverter()
        }
        
        // MARK: triangleForModel
        func testTriangleForModel_hueBulb() {
            let model = "LCT002"
            let expectedResult = Triangle(r: CGPoint(x: 0.675, y: 0.322),
                                          g: CGPoint(x: 0.4091, y: 0.518),
                                          b: CGPoint(x: 0.167, y: 0.04))
            
            let result = sut.triangleForModel(model)
            
            XCTAssertEqual(result, expectedResult)
        }
        
        func testTriangleForModel_livingColors() {
            let model = "LLC013"
            let expectedResult = Triangle(r: CGPoint(x: 0.704, y: 0.296),
                                           g: CGPoint(x: 0.2151, y: 0.7106),
                                           b: CGPoint(x: 0.138, y: 0.08))
            
            let result = sut.triangleForModel(model)
            
            XCTAssertEqual(result, expectedResult)
        }
        
        func testTriangleForModel_unsupportedModel() {
            let model = "unsupported"
            let expectedResult = Triangle(r: CGPoint(x: 1, y: 0),
                                          g: CGPoint(x: 0, y: 1),
                                          b: CGPoint(x: 0, y: 0))
            
            let result = sut.triangleForModel(model)
            
            XCTAssertEqual(result, expectedResult)
        }
        
        // MARK: crossProduct
        func testCrossProduct() {
            let point1 = CGPoint(x: 1, y: 2)
            let point2 = CGPoint(x: 2, y: 1)
            
            let result = sut.crossProduct(point1, point2)
            
            XCTAssertEqual(result, -3.0)
        }
        
        func testCrossProductOtherValues() {
            let point1 = CGPoint(x: 1, y:1)
            let point2 = CGPoint(x: 2, y: 1)
            
            let result = sut.crossProduct(point1, point2)
            
            XCTAssertEqual(result, -1.0)
        }
        
        // MARK: isPointInTrangle
        func testIsPointInTriagnleTrue() {
            let point = CGPoint(x: 2, y: 0)
            let r = CGPoint(x: -1, y: -1)
            let g = CGPoint(x: 3, y: 2)
            let b = CGPoint(x: 3, y: -1)
            let triangle = Triangle(r: r, g: g, b: b)
            
            let result = sut.isPointInTriangle(p: point, triangle: triangle)
            
            XCTAssertEqual(result, true)
        }
        
        func testIsPointInTriagnleFalse() {
            let point = CGPoint(x: 0, y: 1)
            let r = CGPoint(x: -1, y: -1)
            let g = CGPoint(x: 3, y: 2)
            let b = CGPoint(x: 3, y: -1)
            let triangle = Triangle(r: r, g: g, b: b)
            
            let result = sut.isPointInTriangle(p: point, triangle: triangle)
            
            XCTAssertEqual(result, false)
        }
        
        // MARK: closestPointOnLine
        func testClosestPointOnLine() {
            let a = CGPoint(x: -1, y: -1)
            let b = CGPoint(x: 4, y: 2)
            let p = CGPoint(x: 4, y: -1)
            
            let result = sut.closestPointOnLine(a: a, b: b, p: p)
            
            XCTAssertEqual(result, CGPoint(x: 2.6764705882352944, y: 1.2058823529411766))
        }
        
        // MARK: distance
        func testDistance() {
            let p1 = CGPoint(x: -1, y: -1)
            let p2 = CGPoint(x: 4, y: 2)
            
            let result = sut.distance(p1: p1, p2: p2)
            
            XCTAssertEqual(result, 5.830951894845301)
        }
        
        // MARK: xyForModel
        func testXYForModel_hueBulbs() {
            let xy = CGPoint(x: 4, y: 2)
            let model = "LCT002"
            
            let result = sut.xyForModel(xy: xy, model: model)
            
            XCTAssertEqual(result, CGPoint(x: 0.675, y: 0.322))
        }
        
        func testXYForModel_livingColors() {
            let xy = CGPoint(x: 4, y: 2)
            let model = "LLC005"
            
            let result = sut.xyForModel(xy: xy, model: model)
            
            XCTAssertEqual(result, CGPoint(x: 0.704, y: 0.296))
        }
        
        func testXYForModel_unsupported() {
            let xy = CGPoint(x: 4, y: 2)
            let model = "unsupported"
            
            let result = sut.xyForModel(xy: xy, model: model)
            
            XCTAssertEqual(result, CGPoint(x: 1, y: 0))
        }
        
        // MARK: xyBriForModel
        func testXYBriForModel_hueBulbs() {
            let xyBri = XYBri(x: 1, y: 1, bri: 1)
            let model = "LCT002"
            
            let result = sut.xyBriForModel(xyb: xyBri, model: model)
            
            XCTAssertEqual(result, XYBri(x: 0.561760990611976, y: 0.40547065001900223, bri: 1))
        }
        
        func testXYBriForModel_livingColors() {
            let xyBri = XYBri(x: 1, y: 1, bri: 1)
            let model = "LLC012"
            
            let result = sut.xyBriForModel(xyb: xyBri, model: model)
            
            XCTAssertEqual(result, XYBri(x: 0.5289072442648123, y: 0.4444832410059497, bri: 1))
        }
        
        func testXYBriForModel_unsupported() {
            let xyBri = XYBri(x: 1, y: 1, bri: 1)
            let model = "unsupported"
            
            let result = sut.xyBriForModel(xyb: xyBri, model: model)
            
            XCTAssertEqual(result, XYBri(x: 0.5, y: 0.5, bri: 1))
        }
    }
