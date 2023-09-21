import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
    private var theme: Theme
    
    @Published private var model: MemoryGame<String>
    
    convenience init() {
        self.init(theme: Theme.allThemes.randomElement()!)
    }
    
    init(theme: Theme) {
        self.theme = theme
        self.model = MemoryGame(cardContent: theme.randomizedEmojis)
    }
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    private static let themeColors = [
        "red": Color.red,
        "green": .green,
        "blue": .blue,
        "orange": .orange,
        "yellow": .yellow,
        "gray": .gray
    ]
    
    var themeColor: Color {
        Self.themeColors[theme.color] ?? .gray
    }
    
    var themeName: String {
        theme.name
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        self.theme = Theme.allThemes.randomElement()!
        self.model = MemoryGame(cardContent: theme.randomizedEmojis)
    }
}
