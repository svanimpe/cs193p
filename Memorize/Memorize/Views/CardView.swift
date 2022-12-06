import SwiftUI

struct CardView: View {
    
    let card: Card<String>
    
    @State private var animatedBonusPercentage: Double = 0.0
    
    init(_ card: Card<String>) {
        self.card = card
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(start: .degrees(-90), angle: .degrees(-animatedBonusPercentage * 360))
                            .onAppear {
                                animatedBonusPercentage = card.bonusPercentageRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusPercentage = 0
                                }
                            }
                    } else {
                        Pie(start: .degrees(-90), angle: .degrees(-card.bonusPercentageRemaining * 360))
                    }
                }
                .padding(10)
                .opacity(0.5)
                Text(card.content)
                    .font(emojiFont(for: geometry))
                    .rotationEffect(.degrees(card.isMatched ? 360 : 0))
                    .animation(
                        .linear(duration: 1)
                        .repeatForever(autoreverses: false)
                        .delay(0.5),
                        value: card.isMatched
                    )
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
        .aspectRatio(2/3, contentMode: .fit)
    }
    
    private func emojiFont(for geometry: GeometryProxy) -> Font {
        Font.system(size: min(geometry.size.width, geometry.size.height) * 0.65)
    }
}
