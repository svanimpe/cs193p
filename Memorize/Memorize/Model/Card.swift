import Foundation

struct Card<Content>: Identifiable {
    
    let id: UUID
    let content: Content
    
    var isFaceUp: Bool {
        didSet {
            if isFaceUp {
                startUsingBonusTime()
            } else {
                stopUsingBonusTime()
            }
        }
    }
    
    var isMatched: Bool {
        didSet {
            if isMatched {
                stopUsingBonusTime()
            }
        }
    }
    
    var isSeen: Bool
    
    init(id: UUID = UUID(), content: Content, isFaceUp: Bool = false, isMatched: Bool = false, isSeen: Bool = false) {
        self.id = id
        self.content = content
        self.isFaceUp = isFaceUp
        self.isMatched = isMatched
        self.isSeen = isSeen
    }
    
    // MARK: - Bonus Time
    
    private let bonusTimeLimit: TimeInterval = 6
    private var pastFaceUpTime: TimeInterval = 0
    private var lastFaceUpDate: Date? = nil
    
    private var faceUpTime: TimeInterval {
        if let lastFaceUpDate {
            return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
        } else {
            return pastFaceUpTime
        }
    }
    
    var bonusTimeRemaining: TimeInterval {
        max(0, bonusTimeLimit - faceUpTime)
    }
    
    var bonusPercentageRemaining: Double {
        guard bonusTimeLimit > 0 && bonusTimeRemaining > 0 else {
            return 0
        }
        return bonusTimeRemaining / bonusTimeLimit
    }
    
    private var hasEarnedBonus: Bool {
        isMatched && bonusTimeRemaining > 0
    }
    
    var isConsumingBonusTime: Bool {
        isFaceUp && !isMatched && bonusTimeRemaining > 0
    }
    
    mutating func startUsingBonusTime() {
        if isConsumingBonusTime && lastFaceUpDate == nil {
            lastFaceUpDate = Date()
        }
    }
    
    mutating func stopUsingBonusTime() {
        pastFaceUpTime = faceUpTime
        lastFaceUpDate = nil
    }
}
