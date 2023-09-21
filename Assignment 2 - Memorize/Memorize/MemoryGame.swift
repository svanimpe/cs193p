struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    private(set) var score: Int
    
    init(cardContent: some Sequence<CardContent>) {
        cards = []
        for (index, content) in cardContent.enumerated() {
            cards.append(Card(content: content, id: "\(index + 1)a"))
            cards.append(Card(content: content, id: "\(index + 1)b"))
        }
        cards.shuffle()
        score = 0
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
                    score += 2
                } else {
                    if cards[chosenIndex].isSeen {
                        score -= 1
                    } else {
                        cards[chosenIndex].isSeen = true
                    }
                    if cards[potentialMatchIndex].isSeen {
                        score -= 1
                    } else {
                        cards[potentialMatchIndex].isSeen = true
                    }
                }
            } else {
                indexOfFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp = true
        }
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
        
        let content: CardContent
        var isFaceUp = false
        var isMatched = false
        var isSeen = false
        
        let id: String
        
        var debugDescription: String {
            "\(id): \(content) \(isFaceUp ? "up" : "down")\(isMatched ? " matched" : "")\(isSeen ? " seen" : "")"
        }
    }
}

extension Sequence {
    
    func only(matching: (Element) -> Bool) -> Element? {
        let matches = filter(matching)
        return matches.count == 1 ? matches.first : nil
    }
}
