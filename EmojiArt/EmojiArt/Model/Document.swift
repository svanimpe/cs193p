import Foundation

class Document: Codable {
    
    var background: Background
    private(set) var emojis: [Emoji]
    
    init() {
        background = .blank
        emojis = []
    }
    
    func add(_ emoji: Emoji) {
        emojis.append(emoji)
    }
    
    func setPosition(_ emoji: Emoji, x: Int, y: Int) {
        guard let index = emojis.firstIndex(where: { $0.id == emoji.id }) else {
            return
        }
        emojis[index].x = x
        emojis[index].y = y
    }
    
    func setSize(_ emoji: Emoji, _ size: Int) {
        guard let index = emojis.firstIndex(where: { $0.id == emoji.id }) else {
            return
        }
        emojis[index].size = size
    }
    
    func remove(_ emoji: Emoji) {
        emojis.removeAll { $0.id == emoji.id }
    }
}
