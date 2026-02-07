import SwiftUI

extension View {
    @ViewBuilder
    func `if`<Transform: View>(
        _ condition: Bool,
        transform: (Self) -> Transform
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
        #endif
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 10
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let tl = corners.contains(.topLeft)
        let tr = corners.contains(.topRight)
        let bl = corners.contains(.bottomLeft)
        let br = corners.contains(.bottomRight)
        
        let w = rect.size.width
        let h = rect.size.height
        let r = min(radius, min(w, h) / 2)
        
        path.move(to: CGPoint(x: w / 2, y: 0))
        
        path.addLine(to: CGPoint(x: w - (tr ? r : 0), y: 0))
        if tr {
            path.addArc(
                center: CGPoint(x: w - r, y: r),
                radius: r,
                startAngle: Angle(degrees: -90),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
        }
        
        path.addLine(to: CGPoint(x: w, y: h - (br ? r : 0)))
        if br {
            path.addArc(
                center: CGPoint(x: w - r, y: h - r),
                radius: r,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
        }
        
        path.addLine(to: CGPoint(x: (bl ? r : 0), y: h))
        if bl {
            path.addArc(
                center: CGPoint(x: r, y: h - r),
                radius: r,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
        }
        
        path.addLine(to: CGPoint(x: 0, y: (tl ? r : 0)))
        if tl {
            path.addArc(
                center: CGPoint(x: r, y: r),
                radius: r,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
        }
        
        path.closeSubpath()
        return path
    }
}

struct UIRectCorner: OptionSet {
    let rawValue: Int
    
    static let topLeft = UIRectCorner(rawValue: 1 << 0)
    static let topRight = UIRectCorner(rawValue: 1 << 1)
    static let bottomLeft = UIRectCorner(rawValue: 1 << 2)
    static let bottomRight = UIRectCorner(rawValue: 1 << 3)
    static let allCorners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
