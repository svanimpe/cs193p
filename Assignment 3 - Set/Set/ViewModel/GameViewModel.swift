import SwiftUI

class GameViewModel: ObservableObject {
    
    // Because Game is a class, the contents of game never change (it's just a reference),
    // so we have to use objectWillChange instead of @Published to publish changes.
    private var game = Game()
    
    var cards: [Card] {
        game.cardsInPlay
    }
    
    var deckIsEmpty: Bool {
        game.deck.isEmpty
    }
    
    func select(_ card: Card) {
        objectWillChange.send()
        game.select(card)
    }
    
    func drawCards() {
        objectWillChange.send()
        game.drawCards()
    }
    
    func reset() {
        objectWillChange.send()
        game = Game()
    }
}
