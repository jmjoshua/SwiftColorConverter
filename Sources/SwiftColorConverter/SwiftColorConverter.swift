import CoreGraphics

internal struct Triangle: Equatable {
    var r: CGPoint
    var g: CGPoint
    var b: CGPoint
}

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

public struct SwiftColorConverter {
    private var hueBulbs = [
        "LCT001", /* Hue A19 */
        "LCT002", /* Hue BR30 */
        "LCT003" /* Hue GU10 */
    ]
    
    private var livingColors: [String] = [
        "LLC001", /* Monet, Renoir, Mondriaan (gen II) */
        "LLC005", /* Bloom (gen II) */
        "LLC006", /* Iris (gen III) */
        "LLC007", /* Bloom, Aura (gen III) */
        "LLC011", /* Hue Bloom */
        "LLC012", /* Hue Bloom */
        "LLC013", /* Storylight */
        "LST001" /* Light Strips */
    ]
    
    public init() { }
    
    public func rgbToCGPoint(red: CGFloat, green: CGFloat, blue: CGFloat, model: String) -> CGPoint {
        let redC =  (red / 255)
        let greenC = (green / 255)
        let blueC = (blue / 255)

        // Apply gamma correction
        let redN = (redC > 0.04045) ? pow((redC + 0.055) / (1.0 + 0.055), 2.4) : (redC / 12.92)
        let greenN = (greenC > 0.04045) ? pow((greenC + 0.055) / (1.0 + 0.055), 2.4) : (greenC / 12.92)
        let blueN = (blueC > 0.04045) ? pow((blueC + 0.055) / (1.0 + 0.055), 2.4) : (blueC / 12.92)

        // Wide gamut conversion D65
        let X = redN * 0.664511 + greenN * 0.154324 + blueN * 0.162028;
        let Y = redN * 0.283881 + greenN * 0.668433 + blueN * 0.047685;
        let Z = redN * 0.000088 + greenN * 0.072310 + blueN * 0.986039;

        let x = X / (X + Y + Z);
        let y = Y / (X + Y + Z);

        let finalX = round(x * 10000) / 10000
        let finalY = round(y * 10000) / 10000
        
        let result = xyForModel(xy: CGPoint(x: finalX, y: finalY), model: model)
        
        return result
    }
    
    public func cgPointToRGB(_ point: CGPoint, model: String) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        let converted = xyForModel(xy: point, model: model)
        
        let z = 1.0 - converted.x - converted.y
        let x = converted.x / (converted.x + converted.y + z);
        let y = converted.y / (converted.x + converted.y + z);
        
        // Wide gamut D65 conversion
        var r = x  * 1.656492 - y * 0.354851 - z * 0.255038
        var g = -x * 0.707196 + y * 1.655397 + z * 0.036152
        var b = x  * 0.051713 - y * 0.121364 + z * 1.011530

        // Apply gamma correction
        r = r <= 0.0031308 ? 12.92 * r : (1.0 + 0.055) * pow(r, (1.0 / 2.4)) - 0.055
        g = g <= 0.0031308 ? 12.92 * g : (1.0 + 0.055) * pow(g, (1.0 / 2.4)) - 0.055
        b = b <= 0.0031308 ? 12.92 * b : (1.0 + 0.055) * pow(b, (1.0 / 2.4)) - 0.055
        
        return (r: r * 255, g: g * 255, b: b * 255)
    }
    
    public func xyBriToRBG(_ xyb: XYBri) throws -> RGB {
        if 0 > xyb.x || xyb.x > 0.8 {
            throw ConversionError.x(value: xyb.x)
        } else if 0 > xyb.y || xyb.y > 1 {
            throw ConversionError.y(value: xyb.y)
        } else if 0 > xyb.bri || xyb.bri > 1 {
            throw ConversionError.bri(value: xyb.bri)
        }
        
        let x = xyb.x
        let y = xyb.y
        let z = 1.0 - x - y
        
        let Y = xyb.bri
        let X = (Y / y) * x
        let Z = (Y / y) * z
        
        // Wide gamut D65 conversion
        var r = X  * 1.612 - Y * 0.203 - Z * 0.302
        var g = -X * 0.509 + Y * 1.412 + Z * 0.066
        var b = X  * 0.026 - Y * 0.072 + Z * 0.962
        
        // Apply gamma correction
        r = r <= 0.0031308 ? 12.92 * r : (1.0 + 0.055) * pow(r, (1.0 / 2.4)) - 0.055
        g = g <= 0.0031308 ? 12.92 * g : (1.0 + 0.055) * pow(g, (1.0 / 2.4)) - 0.055
        b = b <= 0.0031308 ? 12.92 * b : (1.0 + 0.055) * pow(b, (1.0 / 2.4)) - 0.055
        
        return RGB(r: r * 255, g: g * 255, b: b * 255)
    }
    
    internal func triangleForModel(_ model: String) -> Triangle {
        if hueBulbs.contains(model) {
            return Triangle(r: CGPoint(x: 0.675, y: 0.322),
                            g: CGPoint(x: 0.4091, y: 0.518),
                            b: CGPoint(x: 0.167, y: 0.04))
        } else if livingColors.contains(model) {
            return Triangle(r: CGPoint(x: 0.704, y: 0.296),
                            g: CGPoint(x: 0.2151, y: 0.7106),
                            b: CGPoint(x: 0.138, y: 0.08))
        } else {
            return Triangle(r: CGPoint(x: 1, y: 0),
                            g: CGPoint(x: 0, y: 1),
                            b: CGPoint(x: 0, y: 0))
        }
    }
    
    internal func crossProduct(_ p1: CGPoint, _ p2: CGPoint) -> Float {
        return Float(p1.x * p2.y - p1.y * p2.x)
    }
    
    internal func isPointInTriangle(p: CGPoint, triangle: Triangle) -> Bool {
        let red = triangle.r;
        let green = triangle.g;
        let blue = triangle.b;
        
        let v1 = CGPoint(x: green.x - red.x, y: green.y - red.y)
        let v2 = CGPoint(x: blue.x - red.x,  y: blue.y - red.y)
        let q = CGPoint(x: p.x - red.x, y: p.y - red.y)
        
        let s = crossProduct(q, v2) / crossProduct(v1, v2)
        let t = crossProduct(v1, q) / crossProduct(v1, v2)
        
        return (s >= 0.0) && (t >= 0.0) && (s + t <= 1.0);
    }
    
    internal func closestPointOnLine(a: CGPoint, b: CGPoint, p: CGPoint) -> CGPoint {
        let ap = CGPoint(x: p.x - a.x, y: p.y - a.y)
        let ab = CGPoint(x: b.x - a.x, y: b.y - a.y)
        let ab2 = ab.x * ab.x + ab.y * ab.y
        let ap_ab = ap.x * ab.x + ap.y * ab.y
        
        var t = ap_ab / ab2
        t = min(1, max(0, t))
        
        return CGPoint(x: a.x + ab.x * t, y: a.y + ab.y * t)
    }
    
    internal func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let dx = p1.x - p2.x
        let dy = p1.y - p2.y
        let dist = sqrt(dx * dx + dy * dy)
        
        return dist
    }
    
    public func xyForModel(xy: CGPoint, model: String) -> CGPoint {
        let triangle = triangleForModel(model)
        if (isPointInTriangle(p: xy, triangle: triangle)) {
            return xy
        }
        
        let pAB = closestPointOnLine(a: triangle.r, b: triangle.g, p: xy)
        let pAC = closestPointOnLine(a: triangle.b, b: triangle.r, p: xy)
        let pBC = closestPointOnLine(a: triangle.g, b: triangle.b, p: xy)
        
        let dAB = distance(p1: xy, p2: pAB)
        let dAC = distance(p1: xy, p2: pAC)
        let dBC = distance(p1: xy, p2: pBC)
        
        var lowest = dAB
        var closestPoint = pAB
        
        if dAB < lowest {
            lowest = dAC
            closestPoint = pAC
        }
        
        if dBC < lowest {
            lowest = dBC
            closestPoint = pBC
        }
        
        return closestPoint
    }
    
    public func xyBriForModel(xyb: XYBri, model: String) -> XYBri {
        let point = CGPoint(x: xyb.x, y: xyb.y)
        let xy = xyForModel(xy: point, model: model)
        
        return XYBri(x: xy.x, y: xy.y, bri: xyb.bri)
    }
}
