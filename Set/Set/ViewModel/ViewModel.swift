import SwiftUI

class ViewModel: ObservableObject {
    
    // Because Game is a class, the contents of game never change (it's just a reference),
    // so we have to use objectWillChange instead of @Published to publish changes.
    private var game = Game()
    
    var deck: [Card] {
        game.deck
    }
    
    var cards: [Card] {
        game.cardsInPlay
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
    
    func reset() {
        objectWillChange.send()
        game = Game()
    }
}
