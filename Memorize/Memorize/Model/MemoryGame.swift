import Foundation

struct MemoryGame<Content: Equatable> {
    
    private(set) var cards: [Card<Content>] = []
    private var indexOfFaceUpCard: Int?
    private(set) var score: Int
    
    init(content: some Sequence<Content>) {
        for item in content {
            cards.append(Card(content: item))
            cards.append(Card(content: item))
        }
        cards.shuffle()
        score = 0
    }
    
    mutating func choose(_ card: Card<Content>) {
        let selectedIndex = cards.firstIndex { $0.id == card.id }!
        // Ignore taps on cards that are face up.
        guard !cards[selectedIndex].isFaceUp else {
            return
        }
        // Flip the card.
        cards[selectedIndex].isFaceUp = true
        if let indexOfFaceUpCard {
            // Check for a match.
            if cards[indexOfFaceUpCard].content == cards[selectedIndex].content {
                cards[indexOfFaceUpCard].isMatched = true
                cards[selectedIndex].isMatched = true
                score += 2
            } else {
                if cards[indexOfFaceUpCard].isSeen {
                    score -= 1
                } else {
                    cards[indexOfFaceUpCard].isSeen = true
                }
                if cards[selectedIndex].isSeen {
                    score -= 1
                } else {
                    cards[selectedIndex].isSeen = true
                }
            }
            // Clear the selection.
            self.indexOfFaceUpCard = nil
        } else {
            self.indexOfFaceUpCard = selectedIndex
            // Check if there are cards that need to be flipped face down.
            for index in cards.indices where index != selectedIndex {
                cards[index].isFaceUp = false
            }
        }
    }
    
    // Stops the bonus timers when the user navigates away from a game.
    mutating func stopBonusTimers() {
        for index in cards.indices {
            cards[index].stopUsingBonusTime()
        }
    }
    
    // Resumes the bonus timers when the user returns to a game.
    mutating func resumeBonusTimers() {
        for index in cards.indices {
            if cards[index].isFaceUp && !cards[index].isMatched {
                cards[index].startUsingBonusTime()
            }
        }
    }
}
