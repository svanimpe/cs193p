import SwiftUI

@main
struct MemorizeApp: App {
    
    @StateObject private var store = ThemeStore()
    
    var body: some Scene {
        WindowGroup {
            ThemeList()
                .environmentObject(store)
        }
    }
}
