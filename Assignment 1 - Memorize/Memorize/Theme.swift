struct Theme {
    
    let name: String
    let symbol: String
    let emojis: [String]
    
    static let vehicles = Self.init(name: "Vehicles", symbol: "car.fill", emojis: ["🚗", "🚕", "🚙", "🚌"])
    static let people = Self.init(name: "People", symbol: "person.fill", emojis: ["👩‍🦰", "🧕🏽", "👩🏻‍🌾", "👩‍🏫", "🧑‍✈️", "🎅🏻"])
    static let food = Self.init(name: "Food", symbol: "fork.knife", emojis: ["🍏", "🍎", "🥝", "🍆", "🍕", "🍟", "🥦", "🍞"])
}
