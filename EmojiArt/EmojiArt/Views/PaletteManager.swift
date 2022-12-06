import SwiftUI

struct PaletteManager: View {
    
    @EnvironmentObject var store: PaletteStore
    @Environment(\.isPresented) var isPresented
    @Environment(\.dismiss) var dismiss
    @State var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.palettes) { palette in
                    let index = store.palettes.firstIndex { $0.id == palette.id }!
                    NavigationLink(destination: PaletteEditor(palette: $store.palettes[index])) {
                        VStack(alignment: .leading) {
                            Text(palette.name)
                            Text(palette.emojis)
                        }
                    }
                }
                .onDelete { indexSet in
                    store.palettes.remove(atOffsets: indexSet)
                }
                .onMove { IndexSet, offset in
                    store.palettes.move(fromOffsets: IndexSet, toOffset: offset)
                }
            }
            .navigationTitle("Manage Palettes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if isPresented && UIDevice.current.userInterfaceIdiom != .pad {
                        Button("Close") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)
        }
    }
}


struct PaletteManager_Previews: PreviewProvider {
    
    static var previews: some View {
        PaletteManager()
            .previewDevice("iPhone 14")
            .environmentObject(PaletteStore())
    }
}
