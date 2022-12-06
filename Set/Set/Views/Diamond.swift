import SwiftUI

struct Diamond: InsettableShape {
    
    var inset: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        // Apply the insets.
        let rect = rect.insetBy(dx: inset, dy: inset)
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        // Repeat the first line so there's no gap at the start/end point.
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
    
    // Returns a copy of this shape that is inset by the given amount.
    func inset(by amount: CGFloat) -> Self {
        var copy = self
        copy.inset = amount
        return copy
    }
}
