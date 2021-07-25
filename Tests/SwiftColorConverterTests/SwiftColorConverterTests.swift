    import XCTest
    @testable import SwiftColorConverter

    final class SwiftColorConverterTests: XCTestCase {
        var sut: SwiftColorConverter!
        
        override func setUp() {
            sut = SwiftColorConverter()
        }
        
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
