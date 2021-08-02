//
//  Color+Converter.swift
//  
//
//  Created by Joshua Moore on 7/29/21.
//

import SwiftUI

@available(macOS 10.15, *)
@available(iOS 13.0, *)
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

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension SwiftColorConverter {
    public func color(for xyb: XYBri) throws -> Color {
        let rgb = try SwiftColorConverter().xyBriToRBG(xyb)
        
        return Color(red: Double(rgb.r),
                  green: Double(rgb.g),
                  blue: Double(rgb.b))
    }
}
