import SwiftUI

class PaletteStore: ObservableObject {
    
    // You can use AppStorage to persist observable state in UserDefaults.
    // AppStorage supports only a limited set of types, however,
    // you can store any Codable by converting it to Data.
    @AppStorage("palettes") private var _palettes = Data()
    
    // This computed property encodes/decodes the palettes on-the-fly
    // from the data stored in _palettes.
    var palettes: [Palette] {
        get {
            (try? JSONDecoder().decode([Palette].self, from: _palettes)) ?? []
        }
        set {
            _palettes = (try? JSONEncoder().encode(newValue)) ?? Data()
        }
    }
    
    init() {
        if palettes.isEmpty {
            palettes.append(contentsOf: Palette.defaults)
        }
    }
    
    @discardableResult
    func removePalette(at index: Int) -> Int {
        palettes.remove(at: index)
        if palettes.count == 0 {
            palettes.append(.new)
        }
        return index == palettes.count ? palettes.endIndex : index
    }
}
