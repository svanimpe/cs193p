import SwiftUI

struct PaletteEditor: View {
    
    @Binding var palette: Palette
    @State private var emojisToAdd = ""
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $palette.name)
            } header: {
                Text("Name")
            }
            Section {
                TextField("", text: $emojisToAdd)
                    .onChange(of: emojisToAdd, perform: add(emojis:))
            } header: {
                Text("Add Emojis")
            }
            Section {
                let emojis = palette.emojis.map(String.init)
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: PaletteChooser.defaultEmojiSize))
                ]) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .onTapGesture {
                                emojisToAdd = ""
                                remove(emoji: emoji)
                            }
                    }
                }
                .font(.system(size: PaletteChooser.defaultEmojiSize))
            } header: {
                Text("Remove Emojis")
            }
        }
        .frame(minWidth: 400, minHeight: 550)
        .navigationTitle("Edit \(palette.name)")
    }
    
    private func add(emojis: String) {
        withAnimation {
            palette.emojis = (palette.emojis + emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    private func remove(emoji: String) {
        withAnimation {
            palette.emojis.removeAll { String($0) == emoji }
        }
    }
}

struct PaletteEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        PaletteEditor(palette: .constant(Palette(id: UUID(), name: "People", emojis: "👩‍🦰🧕🏽👩🏻‍🌾👩‍🏫🧑‍✈️🎅🏻👩🏾‍🔧👨🏻‍🎨")))
            .previewLayout(.fixed(width: 300, height: 350))
    }
}
