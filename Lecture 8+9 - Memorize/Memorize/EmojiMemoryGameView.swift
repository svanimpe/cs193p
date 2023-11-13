import SwiftUI

struct EmojiMemoryGameView: View {
    
    typealias Card = EmojiMemoryGame.Card
    
    @ObservedObject var viewModel: EmojiMemoryGame
    @State private var dealt = Set<Card.ID>()
    @State private var lastScoreChange: (Int, causedBy: Card.ID)?
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            cards.foregroundColor(viewModel.color)
            HStack {
                score
                Spacer()
                deck.foregroundColor(viewModel.color)
                Spacer()
                shuffle
            }
        }
        .padding()
    }
    
    private var deck: some View {
        ZStack {
            ForEach(viewModel.cards.filter { !dealt.contains($0.id) }) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: Constants.Deck.width, height: Constants.Deck.width / Constants.aspectRatio)
        .onTapGesture {
            var delay: TimeInterval = 0
            for card in viewModel.cards {
                withAnimation(Constants.Deck.dealAnimation.delay(delay)) {
                    _ = dealt.insert(card.id)
                }
                delay += Constants.Deck.dealInterval
            }
        }
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: Constants.aspectRatio) { card in
            if dealt.contains(card.id) {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .padding(Constants.spacing)
                    .overlay(FlyingNumber(scoreChange(causedBy: card)))
                    .zIndex(scoreChange(causedBy: card) > 0 ? 1 : 0)
                    .onTapGesture {
                        withAnimation {
                            let scoreBefore = viewModel.score
                            viewModel.choose(card)
                            lastScoreChange = (viewModel.score - scoreBefore, causedBy: card.id)
                        }
                    }
            }
        }
    }
    
    private func scoreChange(causedBy card: Card) -> Int {
        lastScoreChange?.1 == card.id ? lastScoreChange!.0 : 0
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
}

extension EmojiMemoryGameView {
    
    private enum Constants {
        
        static let aspectRatio: CGFloat = 2/3
        static let spacing: CGFloat = 4
        
        enum Deck {
            static let width: CGFloat = 50
            static let dealAnimation: Animation = .easeInOut(duration: 1)
            static let dealInterval: TimeInterval = 0.15
        }
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
