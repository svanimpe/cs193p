import SwiftUI

// This type is a first step towards theming support.
// It decides how to render cards, the deck, and the discard pile.
struct Theme {
    
    func view(for card: Card, discarded: Bool = false) -> some View {
        GeometryReader { geometry in
            ZStack {
                background(strokeColor: discarded ? .gray : borderColor(for: card))
                VStack(spacing: geometry.size.width * 0.05) {
                    ForEach(1...card.count.rawValue, id: \.self) { _ in
                        shape(for: card)
                            .foregroundColor(shapeColor(for: card))
                            .aspectRatio(2, contentMode: .fit)
                    }
                }
                .padding(geometry.size.width * 0.15)
            }
        }
    }
    
    var backView: some View {
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(.blue)
    }
    
    var emptyDeckView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray)
                .opacity(0.5)
            Text("∅")
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
    
    var emptyDiscardsView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.gray)
                .opacity(0.5)
            Text("🗑")
                .foregroundColor(.white)
        }
    }
    
    private func background(strokeColor: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(lineWidth: 3)
                .foregroundColor(strokeColor)
        }
    }
    
    private func borderColor(for card: Card) -> Color {
        switch card.status {
        case .deselected:
            return .gray
        case .selected:
            return .yellow
        case .matched:
            return .green
        case .mismatched:
            return .red
        }
    }
    
    @ViewBuilder
    private func shape(for card: Card) -> some View {
        switch (card.shape, card.style) {
        case (.circle, .stroked):
            Circle()
                .strokeBorder(lineWidth: 3)
        case (.circle, .shaded):
            Circle()
                .opacity(0.5)
        case (.circle, .filled):
            Circle()
        case (.diamond, .stroked):
            Diamond()
                .strokeBorder(lineWidth: 3)
        case (.diamond, .shaded):
            Diamond()
                .opacity(0.5)
        case (.diamond, .filled):
            Diamond()
        case (.rectangle, .stroked):
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(lineWidth: 3)
        case (.rectangle, .shaded):
            RoundedRectangle(cornerRadius: 20)
                .opacity(0.5)
        case (.rectangle, .filled):
            RoundedRectangle(cornerRadius: 20)
        }
    }
    
    private func shapeColor(for card: Card) -> Color {
        switch card.color {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        }
    }
}
