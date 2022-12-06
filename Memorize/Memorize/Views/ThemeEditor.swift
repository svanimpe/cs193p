import SwiftUI

struct ThemeEditor: View {
    
    @Binding var theme: Theme<String>
    @State private var emojisToAdd = ""
    @State private var color = Color.clear // Temporary initialization value.
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("Name", text: $theme.name)
                }
                Section(header: Text("Add emojis")) {
                    TextField("Add emojis", text: $emojisToAdd)
                        .onChange(of: emojisToAdd, perform: add(emojis:))
                }
                Section(
                    header: Text("Remove emojis"),
                    footer: Text("Tap to remove emojis. You need to keep at least two.").font(.caption)
                ) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 20))]) {
                        ForEach(theme.symbols, id: \.self) { emoji in
                            Text(emoji)
                                .onTapGesture {
                                    emojisToAdd = ""
                                    remove(emoji: emoji)
                                }
                        }
                    }
                }
                Section(header: Text("Card count")) {
                    Stepper(value: $theme.numberOfPairs, in: 2...$theme.symbols.count) {
                        Text("\(theme.numberOfPairs) pairs")
                    }
                    .onChange(of: theme.symbols) { _ in
                        theme.numberOfPairs = min(theme.numberOfPairs, theme.symbols.count)
                    }
                }
                Section(header: Text("Color")) {
                    ColorPicker(selection: $color, supportsOpacity: false) {
                        Text("Pick a color:")
                    }
                    .onAppear {
                        color = Color(theme.color)
                    }
                    .onChange(of: color) {
                        theme.color = RGBAColor($0)
                    }
                }
            }
            .navigationBarTitle(theme.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Text("Done")
                }
            }
        }
    }
    
    private func add(emojis: String) {
        withAnimation {
            for character in emojis {
                if character.isEmoji && !theme.symbols.contains(String(character)) {
                    theme.symbols.append(String(character))
                }
            }
        }
    }
    
    private func remove(emoji: String) {
        guard theme.symbols.count > 2 else {
            return
        }
        withAnimation {
            theme.symbols.removeAll { $0 == emoji }
        }
    }
}

struct ThemeEditor_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ThemeEditor(theme: .constant(ThemeStore.defaultThemes.first!))
        }
    }
}
