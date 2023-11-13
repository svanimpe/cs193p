import SwiftUI

struct GameView: View {
    
    @ObservedObject var game: GameViewModel
    
    let theme = Theme()
    
    @Namespace private var cards
    
    init(_ game: GameViewModel) {
        self.game = game
    }
        
    var body: some View {
        VStack(spacing: Constants.spacing) {
            AspectRatioVGrid(
                game.cards,
                aspectRatio: Constants.aspectRatio,
                spacing: Constants.cardSpacing
            ) { card in
                theme.view(for: card)
                    .matchedGeometryEffect(id: card.id, in: cards)
                    .onTapGesture {
                        withAnimation {
                            game.select(card)
                        }
                    }
                    .scaleEffect(card.status == .mismatched ? CGSize(width: 0.8, height: 0.8) : CGSize(width: 1, height: 1))
                    .rotationEffect(card.status == .matched ? .degrees(360) : .degrees(0))
                    .animation(.easeInOut, value: card.status)
            }
            controls
        }
        .padding(.horizontal)
        .onAppear {
            withAnimation {
                game.drawCards()
            }
        }
    }
    
    private var controls: some View {
        HStack {
            deck
            Spacer()
            VStack(spacing: 8) {
                Button("New Game") {
                    withAnimation {
                        game.reset()
                    }
                }
                Button("Shuffle") {
                    withAnimation {
                        game.shuffle()
                    }
                }
            }
            Spacer()
            discards
        }
        .padding(.horizontal)
    }
    
    private var deck: some View {
        VStack {
            theme.emptyDeckView
                .overlay(
                    ForEach(game.deck) { card in
                        theme.backView
                            .matchedGeometryEffect(id: card.id, in: cards)
                    }
                )
                .frame(width: Constants.deckWidth, height: Constants.deckHeight)
                .onTapGesture {
                    withAnimation {
                        game.drawCards()
                    }
                }
                .disabled(game.deck.isEmpty)
            Text("Deck")
        }
    }
    
    private var discards: some View {
        VStack {
            theme.emptyDiscardsView
                .overlay(
                    ForEach(game.discards) { card in
                        theme.view(for: card, discarded: true)
                            .matchedGeometryEffect(id: card.id, in: cards)
                    }
                )
                .frame(width: Constants.deckWidth, height: Constants.deckHeight)
            Text("Discards")
        }
    }
    
    private enum Constants {
        static let aspectRatio: CGFloat = 2/3
        static let cardSpacing: CGFloat = 8
        static let spacing: CGFloat = 8
        static let deckWidth: CGFloat = 40
        static let deckHeight: CGFloat = 60
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView(GameViewModel())
    }
}
