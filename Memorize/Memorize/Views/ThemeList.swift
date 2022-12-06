import SwiftUI

struct ThemeList: View {
        
    @EnvironmentObject private var store: ThemeStore
    @State private var editMode: EditMode = .inactive
    @State private var themeToEdit: Theme<String>?
    @State private var games: [Theme<String>: MemoryGameViewModel] = [:]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    if editMode == .active {
                        rowContent(for: theme)
                            .onTapGesture {
                                themeToEdit = theme
                            }
                    } else {
                        NavigationLink(destination: GameView(game: game(for: theme))) {
                            rowContent(for: theme)
                        }
                    }
                }
                .onMove { indexSet, offset in
                    store.themes.move(fromOffsets: indexSet, toOffset: offset)
                }
                .onDelete { indexSet in
                    store.themes.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Memorize")
            .listStyle(.grouped)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: createTheme) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)
        }
        .sheet(item: $themeToEdit, onDismiss: updateGames) { theme in
            let index = store.themes.firstIndex { $0.id == theme.id }!
            ThemeEditor(theme: $store.themes[index])
        }
    }
    
    private func game(for theme: Theme<String>) -> MemoryGameViewModel {
        if let game = games[theme] {
            return game
        } else {
            let game = MemoryGameViewModel(theme: theme)
            games[theme] = game
            return game
        }
    }
    
    private func rowContent(for theme: Theme<String>) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .font(.title2)
                .foregroundColor(Color(theme.color))
            Text(theme.symbolsDescription)
                .font(.subheadline)
        }
    }
    
    private func createTheme() {
        store.appendNewTheme()
        themeToEdit = store.themes.last!
    }
    
    private func updateGames() {
        for theme in store.themes {
            // Look for a theme with the same ID but a different state, which means that theme was edited.
            if let key = games.keys.first(where: { $0.id == theme.id }), key != theme {
                games[key] = nil
            }
        }
    }
}

struct ThemeList_Previews: PreviewProvider {
    
    static var previews: some View {
        ThemeList()
            .environmentObject(ThemeStore())
    }
}
