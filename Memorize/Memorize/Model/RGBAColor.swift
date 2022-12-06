struct RGBAColor: Codable, Hashable {
    
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    static let blue = Self(red: 0, green: 0, blue: 1, alpha: 1)
    static let gray = Self(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    static let green = Self(red: 0, green: 1, blue: 0, alpha: 1)
    static let orange = Self(red: 1, green: 0.75, blue: 0, alpha: 1)
    static let red = Self(red: 1, green: 0, blue: 0, alpha: 1)
    static let yellow = Self(red: 0.9, green: 0.8, blue: 0, alpha: 1)
}
