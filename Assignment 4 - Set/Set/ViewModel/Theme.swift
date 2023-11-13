import SwiftUI

// This is a first step towards theming support.
// This type decides how to render cards.
struct Theme {
    
    func view(for card: Card, discarded: Bool = false) -> some View {
        GeometryReader { geometry in
            let cardShape = RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
            cardShape
                .strokeBorder(lineWidth: Constants.Card.borderWidth)
                .foregroundColor(discarded ? .gray : borderColor(for: card))
                .background(cardShape.fill(.white))
                .overlay(
                    content(for: card, in: geometry)
                )
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
    
    private func content(for card: Card, in geometry: GeometryProxy) -> some View {
        VStack(spacing: geometry.size.width * Constants.Symbol.spacingPercentage) {
            ForEach(1...card.count.rawValue, id: \.self) { _ in
                shape(for: card)
                    .foregroundColor(shapeColor(for: card))
                    .aspectRatio(Constants.Symbol.aspectRatio, contentMode: .fit)
            }
        }
        .padding(geometry.size.width * Constants.Card.paddingPercentage)
    }
    
    @ViewBuilder
    private func shape(for card: Card) -> some View {
        let circle = Circle()
        let diamond = Diamond()
        let rectangle = RoundedRectangle(cornerRadius: Constants.Symbol.cornerRadius)
        switch (card.shape, card.style) {
        case (.circle, .stroked):
            circle.strokeBorder(lineWidth: Constants.Symbol.strokeWidth)
        case (.circle, .shaded):
            circle.opacity(Constants.Symbol.shadingOpacity)
        case (.circle, .filled):
            circle
        case (.diamond, .stroked):
            diamond.strokeBorder(lineWidth: Constants.Symbol.strokeWidth)
        case (.diamond, .shaded):
            diamond.opacity(Constants.Symbol.shadingOpacity)
        case (.diamond, .filled):
            diamond
        case (.rectangle, .stroked):
            rectangle.strokeBorder(lineWidth: Constants.Symbol.strokeWidth)
        case (.rectangle, .shaded):
            rectangle.opacity(Constants.Symbol.shadingOpacity)
        case (.rectangle, .filled):
            rectangle
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
    
    var backView: some View {
        RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
            .foregroundColor(.blue)
    }
    
    var emptyDeckView: some View {
        RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
            .foregroundColor(.gray)
            .opacity(Constants.emptyStackOpacity)
            .overlay(
                Text("∅")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            )
    }
    
    var emptyDiscardsView: some View {
        RoundedRectangle(cornerRadius: Constants.Card.cornerRadius)
            .foregroundColor(.gray)
            .opacity(Constants.emptyStackOpacity)
            .overlay(
                Text("🗑")
                    .foregroundColor(.white)
            )
    }
    
    private enum Constants {
        
        enum Card {
            static let borderWidth: CGFloat = 3
            static let cornerRadius: CGFloat = 10
            static let paddingPercentage: CGFloat = 0.15
        }
        
        enum Symbol {
            static let aspectRatio: CGFloat = 2
            static let cornerRadius: CGFloat = 20
            static let shadingOpacity: CGFloat = 0.5
            static let spacingPercentage: CGFloat = 0.05
            static let strokeWidth: CGFloat = 3
        }
        
        static let emptyStackOpacity: CGFloat = 0.5
    }
}
