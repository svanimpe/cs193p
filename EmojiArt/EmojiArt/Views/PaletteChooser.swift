import SwiftUI

struct PaletteChooser: View {
    
    @EnvironmentObject private var store: PaletteStore
    @State private var selectedIndex = 0
    @State private var isEditing = false
    @State private var isManaging = false
    
    static let defaultEmojiSize: CGFloat = 40
    
    private var selectedPalette: Palette {
        store.palettes[selectedIndex]
    }
    
    var body: some View {
        HStack {
            chooserButton
            ScrollView(.horizontal) {
                HStack {
                    Text(selectedPalette.name)
                    ForEach(selectedPalette.emojis.map { String($0) }, id: \.self) {
                        Text($0)
                            .font(.system(size: Self.defaultEmojiSize))
                            .draggable($0)
                    }
                }
            }
            .id(selectedPalette.id)
            .transition(
                .asymmetric(
                    insertion: .offset(y: Self.defaultEmojiSize),
                    removal: .offset(y: -Self.defaultEmojiSize)
                )
            )
            .popover(isPresented: $isEditing) {
                PaletteEditor(palette: $store.palettes[selectedIndex])
            }
            .sheet(isPresented: $isManaging) {
                PaletteManager()
            }
        }
        .clipped()
        .padding(4)
    }
    
    private var chooserButton: some View {
        Button {
            withAnimation {
                selectedIndex = (selectedIndex + 1) % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
                .font(.system(size: Self.defaultEmojiSize))
        }
        .contextMenu {
            menuButton(title: "Edit", image: "pencil") {
                isEditing = true
            }
            menuButton(title: "New", image: "plus") {
                store.palettes.insert(.new, at: selectedIndex)
                isEditing = true
            }
            menuButton(title: "Delete", image: "minus.circle") {
                store.removePalette(at: selectedIndex)
            }
            menuButton(title: "Manage", image: "slider.vertical.3") {
                isManaging = true
            }
            Menu {
                ForEach(store.palettes) { palette in
                    menuButton(title: palette.name) {
                        selectedIndex = store.palettes.firstIndex { $0.id == palette.id }!
                    }
                }
            } label: {
                Label("Goto", systemImage: "text.insert")
            }
        }
    }
    
    private func menuButton(title: String, image: String? = nil, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation {
                action()
            }
        } label: {
            if let image {
                Label(title, systemImage: image)
            } else {
                Text(title)
            }
            
        }
    }
}
