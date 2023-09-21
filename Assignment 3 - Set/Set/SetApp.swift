import SwiftUI

@main
struct SetApp: App {
    
    @StateObject var game = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            GameView(game)
        }
    }
}
