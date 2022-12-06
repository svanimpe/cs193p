import SwiftUI

extension Character {
    
    var isEmoji: Bool {
        if let firstScalar = unicodeScalars.first, firstScalar.properties.isEmoji {
            return (firstScalar.value >= 0x238d || unicodeScalars.count > 1)
        } else {
            return false
        }
    }
}

extension String {
    
    var removingDuplicateCharacters: String {
        reduce(into: "") { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension CGPoint {
    
    func fromDocumentCoordinates(in geometry: GeometryProxy, scale: Double, offset: CGSize) -> CGPoint {
        let center = (x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        return CGPoint(
            x: self.x * scale + center.x + offset.width,
            y: self.y * scale + center.y + offset.height
        )
    }
    
    func toDocumentCoordinates(in geometry: GeometryProxy, scale: Double, offset: CGSize) -> CGPoint {
        let center = (x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
        return CGPoint(
            x: (self.x - center.x - offset.width) / scale,
            y: (self.y - center.y - offset.height) / scale
        )
    }
}

extension CGSize {
    
    static func + (lhs: Self, rhs: Self) -> Self {
        Self(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    static func += (lhs: inout Self, rhs: Self) {
        lhs.width += rhs.width
        lhs.height += rhs.height
    }
    
    static func * (lhs: Self, rhs: CGFloat) -> Self {
        Self(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    static func / (lhs: Self, rhs: CGFloat) -> Self {
        Self(width: lhs.width / rhs, height: lhs.height / rhs)
    }
}
