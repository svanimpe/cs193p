import Foundation

struct Palette: Identifiable, Codable {
    
    let id: UUID
    var name: String
    var emojis: String
    
    static var new: Palette {
        Palette(id: UUID(), name: "New", emojis: "")
    }
    
    static var defaults: [Palette] = [
        Palette(id: UUID(), name: "Vehicles", emojis: "🚗🚕🚙🚌🚎🏎🚓🚑"),
        Palette(id: UUID(), name: "People", emojis: "👩‍🦰🧕🏽👩🏻‍🌾👩‍🏫🧑‍✈️🎅🏻👩🏾‍🔧👨🏻‍🎨"),
        Palette(id: UUID(), name: "Food", emojis: "🍏🍎🥝🍆🍕🍟🥦🍞"),
        Palette(id: UUID(), name: "Animals", emojis: "🐶🐱🐭🐹🐰🦊🐻🐼"),
        Palette(id: UUID(), name: "Buildings", emojis: "⛺️🏢💒🏠🏛🕌🏦🏭")
    ]
}
