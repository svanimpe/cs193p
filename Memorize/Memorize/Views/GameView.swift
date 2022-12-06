import SwiftUI

struct GameView: View {
    
    @ObservedObject var game: MemoryGameViewModel
    @State private var dealtCards: Set<UUID> = []
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        VStack {
            AspectRatioVGrid(game.cards, aspectRatio: 2/3, spacing: 10) { card in
                if !dealtCards.contains(card.id) || card.isMatched && !card.isFaceUp {
                    Color.clear
                } else {
                    CardView(card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(
                            .asymmetric(
                                insertion: .identity,
                                removal: .scale.animation(.easeInOut(duration: 0.5))
                            )
                        )
                        .zIndex(zIndex(for: card))
                        .foregroundColor(Color(game.theme.color))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                game.choose(card)
                            }
                        }
                }
            }
            deck
            Text("Score: **\(game.score)**")
        }
        .padding()
        .navigationTitle(game.theme.name)
        .toolbar {
            Button("New Game") {
                dealtCards = []
                game.newGame()
            }
        }
        .onAppear {
            if game.hasStarted {
                // Skip dealing the cards.
                for card in game.cards {
                    dealtCards.insert(card.id)
                }
                game.resumeBonusTimers()
            } else {
                game.hasStarted = true
            }
        }
        .onDisappear {
            game.stopBonusTimers()
        }
    }

    private var deck: some View {
        ZStack {
            ForEach(game.cards.filter { !dealtCards.contains($0.id) }) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(
                        .asymmetric(
                            insertion: .opacity.animation(.easeInOut(duration: 0.5)),
                            removal: .scale(scale: 1)
                        )
                    )
                    .transition(.scale(scale: 1))
                    .foregroundColor(Color(game.theme.color))
                    .zIndex(zIndex(for: card))
            }
        }
        .frame(width: 60, height: 90)
        .onTapGesture {
            for card in game.cards {
                _ = withAnimation(dealAnimation(for: card)) {
                    dealtCards.insert(card.id)
                }
            }
        }
    }
    
    private let dealDuration: Double = 1
    private let totalDealDuration: Double = 2
    
    private func dealAnimation(for card: Card<String>) -> Animation {
        let index = game.cards.firstIndex { $0.id == card.id }!
        let delayPerCard = (totalDealDuration - dealDuration) / Double(game.cards.count - 1)
        return Animation.easeInOut(duration: dealDuration).delay(Double(index) * delayPerCard)
    }
    
    private func zIndex(for card: Card<String>) -> Double {
        Double(-game.cards.firstIndex { $0.id == card.id }!)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView(game: MemoryGameViewModel(theme: ThemeStore.defaultThemes.first!))
    }
}
