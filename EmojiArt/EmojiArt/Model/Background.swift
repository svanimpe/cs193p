import Foundation

enum Background: Codable {
    
    case blank
    case url(URL)
    case data(Data)
}
