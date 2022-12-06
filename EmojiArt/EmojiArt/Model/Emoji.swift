import Foundation

struct Emoji: Identifiable, Codable {
    
    let id: UUID
    let text: String
    var x: Int
    var y: Int
    var size: Int
}
