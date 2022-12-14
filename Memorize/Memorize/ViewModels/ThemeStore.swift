import SwiftUI

class ThemeStore: ObservableObject {
    
    static let defaultThemes = [
        Theme(
            name: "Vehicles",
            color: .blue,
            symbols: ["π", "π", "π", "π", "π", "π", "π", "π"],
            numberOfPairs: 8
        ),
        Theme(
            name: "People",
            color: .yellow,
            symbols: ["π©βπ¦°", "π§π½", "π©π»βπΎ", "π©βπ«", "π§ββοΈ", "ππ»", "π©πΎβπ§", "π¨π»βπ¨"],
            numberOfPairs: 8
        ),
        Theme(
            name: "Food",
            color: .green,
            symbols: ["π", "π", "π₯", "π", "π", "π", "π₯¦", "π"],
            numberOfPairs: 8
        ),
        Theme(
            name: "Animals",
            color: .orange,
            symbols: ["πΆ", "π±", "π­", "πΉ", "π°", "π¦", "π»", "πΌ"],
            numberOfPairs: 6
        ),
        Theme(
            name: "Buildings",
            color: .gray,
            symbols: ["βΊοΈ", "π’", "π", "π ", "π", "π", "π¦", "π­"],
            numberOfPairs: 6
        ),
        Theme(
            name: "Sports",
            color: .red,
            symbols: ["β½οΈ", "π₯", "π", "π", "π", "β³οΈ", "π", "π€ΈββοΈ"],
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
            Theme(name: "New", color: .gray, symbols: ["π", "π"], numberOfPairs: 2)
        )
    }
}
