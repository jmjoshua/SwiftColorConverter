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
    }
