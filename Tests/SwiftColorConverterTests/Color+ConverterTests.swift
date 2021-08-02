//
//  Color+ConverterTests.swift
//  
//
//  Created by Joshua Moore on 7/29/21.
//

import XCTest
import SwiftUI

@testable import SwiftColorConverter

final class ColorConverterExtensionTests: XCTestCase {
    var sut: SwiftColorConverter!
    
    override func setUp() {
        sut = SwiftColorConverter()
    }
    
    private func getErrorMessage(for error: Error) -> String {
        if let error = error as? ConversionError {
            return error.message
        } else {
            return error.localizedDescription
        }
    }
    
    // MARK: xyBriToRGB
    func testColorFromXYB() {
//        let xyBri = XYBri(x: 0.2, y: 0.2, bri: 0.4)
//        let model = "LCT002"
//        let expectedResult = Color.green
//        
//        do {
//            let result = try Color(xyb: xyBri, model: model)
//            
//            XCTAssertEqual(result, expectedResult)
//        } catch let error {
//            let errorMessage = getErrorMessage(for: error)
//            
//            XCTFail(errorMessage)
//        }
    }
}
