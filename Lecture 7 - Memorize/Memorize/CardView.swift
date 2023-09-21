import SwiftUI

struct CardView: View {
    
    typealias Card = MemoryGame<String>.Card
    
    private let card: Card
    
    init(_ card: Card) {
        self.card = card
    }
    
    var body: some View {
        Pie(endAngle: .degrees(240))
            .opacity(Constants.Pie.opacity)
            .overlay(
                Text(card.content)
                    .font(.system(size: Constants.FontSize.largest))
                    .minimumScaleFactor(Constants.FontSize.scaleFactor)
                    .multilineTextAlignment(.center)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(Constants.Pie.inset)
            )
            .padding(Constants.inset)
            .cardify(isFaceUp: card.isFaceUp)
            .opacity(card.isMatched && !card.isFaceUp ? 0 : 1)
    }
}

extension CardView {
    
    private enum Constants {

        static let inset: CGFloat = 5
        
        enum FontSize {
            
            static let largest: CGFloat = 200
            static let smallest: CGFloat = 10
            static let scaleFactor: CGFloat = smallest / largest
        }
        
        enum Pie {
            
            static let opacity: CGFloat = 0.5
            static let inset: CGFloat = 5
        }
    }
}

struct CardView_Previews: PreviewProvider {
    
    typealias Card = CardView.Card
    
    static var previews: some View {
        VStack {
            HStack {
                CardView(Card(content: "X", isFaceUp: true, id: "test"))
                    .padding(4)
                    .foregroundColor(.green)
                CardView(Card(content: "X", id: "test"))
                    .padding(4)
                    .foregroundColor(.green)
            }
            HStack {
                CardView(Card(content: "This is a very long string and I hope it fits", isFaceUp: true, isMatched: true, id: "test"))
                    .padding(4)
                    .foregroundColor(.green)
                CardView(Card(content: "X", isMatched: true, id: "test"))
                    .padding(4)
                    .foregroundColor(.green)
            }
        }
    }
}
