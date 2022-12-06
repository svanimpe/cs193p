import SwiftUI

struct Pie: Shape {
    
    var start: Angle
    var angle: Angle
    
    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(start.degrees, angle.degrees)
        }
        set {
            start = .degrees(newValue.first)
            angle = .degrees(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startPoint = CGPoint(
            x: center.x + radius * cos(start.radians),
            y: center.y + radius * sin(start.radians)
        )
        path.move(to: center)
        path.addLine(to: startPoint)
        path.addRelativeArc(center: center, radius: radius, startAngle: start, delta: angle)
        path.addLine(to: center)
        return path
    }
}
