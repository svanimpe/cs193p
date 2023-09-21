import SwiftUI

struct GameView: View {
    
    @ObservedObject var game: GameViewModel
    
    let theme = Theme()
    
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
                    .onTapGesture {
                        game.select(card)
                    }
            }
            Button("Deal 3 More Cards", action: game.drawCards)
                .disabled(game.deckIsEmpty)
            Button("New Game", action: game.reset)
        }
        .padding(.horizontal)
    }
    
    private enum Constants {
        static let aspectRatio: CGFloat = 2/3
        static let cardSpacing: CGFloat = 8
        static let spacing: CGFloat = 8
    }
}

struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView(GameViewModel())
    }
}
