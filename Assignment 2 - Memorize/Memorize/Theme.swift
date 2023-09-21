struct Theme {
    
    let name: String
    let emojis: [String]
    let numberOfPairs: Int
    let color: String
    
    init(name: String, emojis: [String], numberOfPairs: Int, color: String) {
        precondition(numberOfPairs >= 2 && numberOfPairs <= emojis.count)
        self.name = name
        self.emojis = emojis
        self.numberOfPairs = numberOfPairs
        self.color = color
    }
    
    var randomizedEmojis: some Sequence<String> {
        emojis.shuffled().prefix(numberOfPairs)
    }
    
    static let allThemes = [
        Self(name: "Vehicles", emojis: ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑"], numberOfPairs: 8, color: "blue"),
        Self(name: "People", emojis: ["👩‍🦰", "🧕🏽", "👩🏻‍🌾", "👩‍🏫", "🧑‍✈️", "🎅🏻", "👩🏾‍🔧", "👨🏻‍🎨"], numberOfPairs: 8, color: "yellow"),
        Self(name: "Food", emojis: ["🍏", "🍎", "🥝", "🍆", "🍕", "🍟", "🥦", "🍞"], numberOfPairs: 8, color: "green"),
        Self(name: "Animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼"], numberOfPairs: 6, color: "orange"),
        Self(name: "Buildings", emojis: ["⛺️", "🏢", "💒", "🏠", "🏛", "🕌", "🏦", "🏭"], numberOfPairs: 6, color: "gray"),
        Self(name: "Sports", emojis: ["⚽️", "🥏", "🏀", "🏈", "🏓", "⛳️", "🏑", "🤸‍♀️"], numberOfPairs: 6, color: "red")
    ]
}
