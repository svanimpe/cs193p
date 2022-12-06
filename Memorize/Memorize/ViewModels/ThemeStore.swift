import SwiftUI

class ThemeStore: ObservableObject {
    
    static let defaultThemes = [
        Theme(
            name: "Vehicles",
            color: .blue,
            symbols: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑"],
            numberOfPairs: 8
        ),
        Theme(
            name: "People",
            color: .yellow,
            symbols: ["👩‍🦰", "🧕🏽", "👩🏻‍🌾", "👩‍🏫", "🧑‍✈️", "🎅🏻", "👩🏾‍🔧", "👨🏻‍🎨"],
            numberOfPairs: 8
        ),
        Theme(
            name: "Food",
            color: .green,
            symbols: ["🍏", "🍎", "🥝", "🍆", "🍕", "🍟", "🥦", "🍞"],
            numberOfPairs: 8
        ),
        Theme(
            name: "Animals",
            color: .orange,
            symbols: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"],
            numberOfPairs: 6
        ),
        Theme(
            name: "Buildings",
            color: .gray,
            symbols: ["⛺️", "🏢", "💒", "🏠", "🏛", "🕌", "🏦", "🏭"],
            numberOfPairs: 6
        ),
        Theme(
            name: "Sports",
            color: .red,
            symbols: ["⚽️", "🥏", "🏀", "🏈", "🏓", "⛳️", "🏑", "🤸‍♀️"],
            numberOfPairs: 6
        )
    ]
    
    // You can use AppStorage to persist observable state in UserDefaults.
    // AppStorage supports only a limited set of types, however,
    // you can store any Codable by converting it to Data.
    @AppStorage("themes") private var _themes = Data()
    
    // This computed property encodes/decodes the themes on-the-fly
    // from the data stored in _themes.
    var themes: [Theme<String>] {
        get {
            (try? JSONDecoder().decode([Theme<String>].self, from: _themes)) ?? []
        } set {
            _themes = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    init() {
        if themes.isEmpty {
            themes = Self.defaultThemes
        }
    }
    
    func appendNewTheme() {
        themes.append(
            Theme(name: "New", color: .gray, symbols: ["🙂", "🙃"], numberOfPairs: 2)
        )
    }
}
