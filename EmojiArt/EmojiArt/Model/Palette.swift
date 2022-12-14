import Foundation

struct Palette: Identifiable, Codable {
    
    let id: UUID
    var name: String
    var emojis: String
    
    static var new: Palette {
        Palette(id: UUID(), name: "New", emojis: "")
    }
    
    static var defaults: [Palette] = [
        Palette(id: UUID(), name: "Vehicles", emojis: "ππππππππ"),
        Palette(id: UUID(), name: "People", emojis: "π©βπ¦°π§π½π©π»βπΎπ©βπ«π§ββοΈππ»π©πΎβπ§π¨π»βπ¨"),
        Palette(id: UUID(), name: "Food", emojis: "πππ₯ππππ₯¦π"),
        Palette(id: UUID(), name: "Animals", emojis: "πΆπ±π­πΉπ°π¦π»πΌ"),
        Palette(id: UUID(), name: "Buildings", emojis: "βΊοΈπ’ππ πππ¦π­")
    ]
}
