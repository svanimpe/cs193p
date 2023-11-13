import Foundation

class Game {
    
    private(set) var deck: [Card]
    private(set) var cardsInPlay: [Card]
    private(set) var discards: [Card]
    
    init() {
        deck = []
        deck.reserveCapacity(81)
        for count in Card.Count.allCases {
            for color in Card.Color.allCases {
                for style in Card.Style.allCases {
                    for shape in Card.Shape.allCases {
                        deck.append(Card(count, color, style, shape))
                    }
                }
            }
        }
        deck.shuffle()
        cardsInPlay = []
        discards = []
    }
    
    private var selectedCards: [Card] {
        cardsInPlay.filter {
            $0.status.isOneOf(.selected, .matched, .mismatched)
        }
    }
    
    private var selectedIndices: [Int] {
        cardsInPlay.indices.filter {
            cardsInPlay[$0].status.isOneOf(.selected, .matched, .mismatched)
        }
    }
    
    func select(_ card: Card) {
        if selectedCards.count < 3 {
            let index = cardsInPlay.firstIndex { $0.id == card.id }!
            if cardsInPlay[index].status == .selected {
                cardsInPlay[index].status = .deselected
            } else {
                cardsInPlay[index].status = .selected
                if selectedCards.count == 3 {
                    let haveSet = selectedCards.makesSet
                    selectedIndices.forEach {
                        cardsInPlay[$0].status = haveSet ? .matched : .mismatched
                    }
                }
            }
        } else if selectedCards.isMatched {
            discards.append(contentsOf: selectedCards)
            cardsInPlay.removeAll { $0.status == .matched }
            if card.status != .matched {
                let index = cardsInPlay.firstIndex { $0.id == card.id }!
                cardsInPlay[index].status = .selected
            }
        } else {
            selectedIndices.forEach {
                cardsInPlay[$0].status = .deselected
            }
            let index = cardsInPlay.firstIndex { $0.id == card.id }!
            cardsInPlay[index].status = .selected
        }
    }
    
    func drawCards() {
        if deck.count == 81 {
            cardsInPlay = Array(deck.suffix(12))
            deck.removeLast(12)
        } else if selectedCards.isMatched {
            discards.append(contentsOf: selectedCards)
            cardsInPlay.removeAll { $0.status == .matched }
            addCards()
        } else if !deck.isEmpty {
            addCards()
        }
    }
    
    private func addCards() {
        cardsInPlay.append(contentsOf: deck.suffix(3))
        deck = Array(deck.dropLast(3))
    }
    
    func shuffle() {
        cardsInPlay.shuffle()
    }
}
