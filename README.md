# SwiftColorConverter

Color converter for Hue API. 

#### Terms:
- Model - Hue light model (returned by Hue REST API, dictates color conversion method)
- XYB - x, y, brightness (accepted by Hue REST API)
- RGB - red, green, blue

## Upcoming Features:
#### SwiftUI Color Extensions
 - Create a SwiftUI.Color object from XYB - Receive x, y, brightness values from Hue API and convert to Color on initialization.
 - Get XYB from SwiftUI.Color - Convert Color object into values that can be sent to Hue API.

#### Functions:
- public func xyBriToRBG(_ xyb: XYBri) throws -> RGB
- public func xyForModel(xy: CGPoint, model: String) -> CGPoint
- public func xyBriForModel(xyb: XYBri, model: String) -> XYBri

#### Models
public struct XYBri: Equatable {
    var x: CGFloat
    var y: CGFloat
    var bri: CGFloat
}

public struct RGB: Equatable {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
}

#### Error Types
public enum ConversionError: Error, Equatable {
    case x(value: CGFloat)
    case y(value: CGFloat)
    case bri(value: CGFloat)
    case rgb
    
    var message: String {
        switch self {
        case .x(let value):
            return "x property must be between 0 and .8, but is: \(value)"
        case .y(let value):
            return "y property must be between 0 and 1, but is: \(value)"
        case .bri(let value):
            return "bri property must be between 0 and 1, but is: \(value)"
        case .rgb:
            return "r, g, and, b properties must be between 0 and 1"
        }
    }
}
