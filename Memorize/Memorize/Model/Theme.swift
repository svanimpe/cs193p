import Foundation

struct Theme<Content>: Identifiable, Codable, Hashable where Content: Codable & Hashable {
    
    let id: UUID
    var name: String
    var color: RGBAColor
    var symbols: [Content]
    var numberOfPairs: Int
    
    init(id: UUID = UUID(), name: String, color: RGBAColor, symbols: [Content], numberOfPairs: Int) {
        self.id = id
        self.name = name
        self.color = color
        self.symbols = symbols
        self.numberOfPairs = min(numberOfPairs, symbols.count)
    }
    
    var randomizedSymbols: ArraySlice<Content> {
        symbols.shuffled().prefix(numberOfPairs)
    }
}

extension Theme where Content: CustomStringConvertible {
    
    var symbolsDescription: String {
        let symbols = symbols.map(String.init).joined()
        if numberOfPairs == symbols.count {
            return "All of \(symbols)"
        } else {
            return "\(numberOfPairs) pairs from \(symbols)"
        }
    }
}
