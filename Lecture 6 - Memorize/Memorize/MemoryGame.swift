struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    
    init(numberOfPairs: Int, cardContent: [CardContent]) {
        precondition(numberOfPairs >= 2 && numberOfPairs <= cardContent.count)
        cards = []
        for index in 0..<numberOfPairs {
            cards.append(Card(content: cardContent[index], id: "\(index + 1)a"))
            cards.append(Card(content: cardContent[index], id: "\(index + 1)b"))
        }
    }
    
    private var indexOfFaceUpCard: Int? {
        get {
            cards.indices.only { cards[$0].isFaceUp }
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    mutating func choose(_ card: Card) {
        let chosenIndex = cards.firstIndex(of: card)!
        if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
            if let potentialMatchIndex = indexOfFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
            } else {
                indexOfFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
        
        let id: String
        
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? " matched" : "")"
        }
    }
}

extension Sequence {
    
    func only(matching: (Element) -> Bool) -> Element? {
        let matches = filter(matching)
        return matches.count == 1 ? matches.first : nil
    }
}
