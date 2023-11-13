import SwiftUI

class GameViewModel: ObservableObject {
    
    // Because Game is a class, the contents of game never change (it's just a reference),
    // so we have to use objectWillChange instead of @Published to publish changes.
    private var game = Game()
    
    var cards: [Card] {
        game.cardsInPlay
    }
    
    var deck: [Card] {
        game.deck
    }
    
    var discards: [Card] {
        game.discards
    }
    
    func select(_ card: Card) {
        objectWillChange.send()
        game.select(card)
    }
    
    func drawCards() {
        objectWillChange.send()
        game.drawCards()
    }
    
    // This isn't fully compatible with Required Task 8:
    // You won't see the cards flying out of the deck when the game is reset.
    // This is because the cards in the new game have different IDs from the cards in the old game,
    // so their geometries cannot be matched.
    // You could fix this by using different IDs, but that may cause other issues.
    func reset() {
        objectWillChange.send()
        game = Game()
        game.drawCards()
    }
    
    func shuffle() {
        objectWillChange.send()
        game.shuffle()
    }
}
