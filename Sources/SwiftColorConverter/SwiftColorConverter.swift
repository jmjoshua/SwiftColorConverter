import CoreGraphics

public struct Triangle: Equatable {
    var r: CGPoint
    var g: CGPoint
    var b: CGPoint
}

public struct XYBri: Equatable {
    var x: CGFloat
    var y: CGFloat
    var bri: CGFloat
}

struct RGB {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
}

public struct SwiftColorConverter {
    var hueBulbs = [
        "LCT001", /* Hue A19 */
        "LCT002", /* Hue BR30 */
        "LCT003" /* Hue GU10 */
    ]
    var livingColors: [String] = [
        "LLC001", /* Monet, Renoir, Mondriaan (gen II) */
        "LLC005", /* Bloom (gen II) */
        "LLC006", /* Iris (gen III) */
        "LLC007", /* Bloom, Aura (gen III) */
        "LLC011", /* Hue Bloom */
        "LLC012", /* Hue Bloom */
        "LLC013", /* Storylight */
        "LST001" /* Light Strips */
    ]
    
    public init() {
        
    }
    
    func triangleForModel(_ model: String) -> Triangle {
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
    
    func crossProduct(_ p1: CGPoint, _ p2: CGPoint) -> Float {
        return Float(p1.x * p2.y - p1.y * p2.x)
    }
    
    func isPointInTriangle(p: CGPoint, triangle: Triangle) -> Bool {
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
    
    func closestPointOnLine(a: CGPoint, b: CGPoint, p: CGPoint) -> CGPoint {
        let ap = CGPoint(x: p.x - a.x, y: p.y - a.y)
        let ab = CGPoint(x: b.x - a.x, y: b.y - a.y)
        let ab2 = ab.x * ab.x + ab.y * ab.y
        let ap_ab = ap.x * ab.x + ap.y * ab.y
        
        var t = ap_ab / ab2
        t = min(1, max(0, t))
        
        return CGPoint(x: a.x + ab.x * t, y: a.y + ab.y * t)
    }
    
    func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
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
