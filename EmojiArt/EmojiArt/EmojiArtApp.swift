import SwiftUI

@main
struct EmojiArtApp: App {
    
    @StateObject var paletteStore = PaletteStore()
    
    var body: some Scene {
        WindowGroup {
            DocumentView()
                .environmentObject(paletteStore)
        }
    }
}
