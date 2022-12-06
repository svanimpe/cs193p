import SwiftUI

struct Cardify: ViewModifier, Animatable {
    
    var animatableData: Double
    
    init(isFaceUp: Bool) {
        // Fixes "ignoring singular matrix" warnings (avoid zero).
        animatableData = isFaceUp ? 0.001 : 180
    }
    
    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: 10)
        ZStack {
            if animatableData < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
            } else {
                shape.fill()
            }
            content.opacity(animatableData < 90 ? 1 : 0) 
        }
        .rotation3DEffect(.degrees(animatableData), axis: (0, 1, 0))
    }
}

extension View {
    
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
