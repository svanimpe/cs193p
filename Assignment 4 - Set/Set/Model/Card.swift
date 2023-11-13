import Foundation

struct Card: Identifiable {
    
    enum Count: Int, CaseIterable {
        case single = 1
        case double
        case triple
    }
    
    enum Color: CaseIterable {
        case red
        case green
        case blue
    }
    
    enum Style: CaseIterable {
        case stroked
        case shaded
        case filled
    }
    
    enum Shape: CaseIterable {
        case circle
        case diamond
        case rectangle
    }
    
    enum Status {
        case deselected
        case selected
        case matched
        case mismatched
    }
    
    let id: UUID
    let count: Count
    let color: Color
    let style: Style
    let shape: Shape
    var status: Status
    
    init(id: UUID = UUID(), _ count: Count, _ color: Color, _ style: Style, _ shape: Shape) {
        self.id = id
        self.count = count
        self.color = color
        self.style = style
        self.shape = shape
        self.status = .deselected
    }
}

extension [Card] {
    
    var isMatched: Bool {
        count == 3 && allSatisfy { $0.status == .matched }
    }
    
    var makesSet: Bool {
        count == 3
            && allSameOrAllDifferent(\.count)
            && allSameOrAllDifferent(\.color)
            && allSameOrAllDifferent(\.style)
            && allSameOrAllDifferent(\.shape)
    }
    
    private func allSameOrAllDifferent(_ key: KeyPath<Card, some Equatable>) -> Bool {
        self[0][keyPath: key] == self[1][keyPath: key] &&
        self[0][keyPath: key] == self[2][keyPath: key]
        ||
        self[0][keyPath: key] != self[1][keyPath: key] &&
        self[1][keyPath: key] != self[2][keyPath: key] &&
        self[0][keyPath: key] != self[2][keyPath: key]
    }
}
