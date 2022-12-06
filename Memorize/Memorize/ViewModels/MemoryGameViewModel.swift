import SwiftUI

class MemoryGameViewModel: ObservableObject {
    
    @Published private var model: MemoryGame<String>
    let theme: Theme<String>
    var hasStarted: Bool
    
    init(theme: Theme<String>) {
        self.theme = theme
        model = MemoryGame(content: theme.randomizedSymbols)
        hasStarted = false
    }
    
    var cards: [Card<String>] {
        model.cards
    }
    
    func choose(_ card: Card<String>) {
        model.choose(card)
    }
    
    func newGame() {
        model = MemoryGame(content: theme.randomizedSymbols)
        hasStarted = false
    }
    
    var score: Int {
        model.score
    }
    
    func stopBonusTimers() {
        model.stopBonusTimers()
    }
    
    func resumeBonusTimers() {
        model.resumeBonusTimers()
    }
}
