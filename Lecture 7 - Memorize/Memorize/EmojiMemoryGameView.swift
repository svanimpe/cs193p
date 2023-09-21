import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame
        
    var body: some View {
        VStack {
            cards
                .foregroundColor(viewModel.color)
                .animation(.default, value: viewModel.cards)
            Button("Shuffle") {
                viewModel.shuffle()
            }
        }
        .padding()
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: Constants.aspectRatio) { card in
            CardView(card)
                .padding(Constants.spacing)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
    }
}

extension EmojiMemoryGameView {
    
    enum Constants {
        
        static let aspectRatio: CGFloat = 2/3
        static let spacing: CGFloat = 4
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
