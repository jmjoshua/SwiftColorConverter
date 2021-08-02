//
//  Color+Converter.swift
//  
//
//  Created by Joshua Moore on 7/29/21.
//

import SwiftUI

@available(macOS 10.15, *)
extension Color {
    public init(xyb: XYBri, model: String) throws {
        let rgb = try SwiftColorConverter().xyBriToRBG(xyb)
        
        self.init(red: Double(rgb.r),
                  green: Double(rgb.g),
                  blue: Double(rgb.b))
    }
    
    func toXY(for model: String) -> CGPoint {
        return CGPoint()
    }
}
