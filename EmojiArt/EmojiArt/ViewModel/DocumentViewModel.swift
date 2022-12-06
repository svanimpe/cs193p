import SwiftUI

// Changes to this view model trigger UI updates,
// so these changes must happen on the main actor (main thread).
@MainActor
class DocumentViewModel: ObservableObject {
    
    enum ImageFetchStatus: Equatable {
        case idle
        case loading
        case failed
    }
    
    // Because Document is a class, the contents of document never change (it's just a reference),
    // so we have to use objectWillChange instead of @Published to publish changes.
    private var document: Document
    
    init() {
        if let document = Self.loadAutosave() {
            self.document = document
        } else {
            self.document = Document()
        }
    }
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundFetchStatus = ImageFetchStatus.idle
    
    var background: Background {
        document.background
    }
    
    func setBackground(_ background: Background) async {
        objectWillChange.send()
        document.background = background
        await fetchBackgroundImage()
        autosave()
    }
    
    func fetchBackgroundImage() async {
        switch document.background {
        case .url(let url):
            backgroundFetchStatus = .loading
            if let response = try? await URLSession.shared.data(from: url),
               let image = UIImage(data: response.0) {
                backgroundImage = image
                backgroundFetchStatus = .idle
            } else {
                backgroundFetchStatus = .failed
            }
        case .data(let data):
            backgroundImage = UIImage(data: data)
        default:
            backgroundImage = nil
        }
    }
    
    var emojis: [Emoji] {
        document.emojis
    }
    
    func addEmoji(text: String, x: CGFloat, y: CGFloat, size: CGFloat) {
        objectWillChange.send()
        document.add(
            Emoji(id: UUID(), text: text, x: Int(x), y: Int(y), size: Int(size))
        )
        autosave()
    }
    
    func move(_ emoji: Emoji, by offset: CGSize) {
        objectWillChange.send()
        document.setPosition(emoji, x: Int(CGFloat(emoji.x) + offset.width), y: Int(CGFloat(emoji.y) + offset.height))
        autosave()
    }
    
    func zoom(_ emoji: Emoji, scale: CGFloat) {
        objectWillChange.send()
        document.setSize(emoji, Int(CGFloat(emoji.size) * scale))
        autosave()
    }
    
    func remove(_ emoji: Emoji) {
        objectWillChange.send()
        document.remove(emoji)
        autosave()
    }
}

extension DocumentViewModel {
        
    private enum Autosave {
        
        static let filename = "autosave.emojiart"

        static var url: URL? {
            guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            return url.appending(component: filename)
        }
        
        static var timer: Timer?
        static let interval: TimeInterval = 5
    }
    
    private func save(to file: URL) {
        do {
            let data = try JSONEncoder().encode(document)
            try data.write(to: file)
        } catch {
            print("Failed to save document: \(error)")
        }
    }
    
    private func autosave() {
        guard let url = Autosave.url else {
            return
        }
        Autosave.timer?.invalidate()
        Autosave.timer = Timer.scheduledTimer(withTimeInterval: Autosave.interval, repeats: false) { _ in
            self.save(to: url)
        }
    }
    
    private static func loadAutosave() -> Document? {
        guard let url = Autosave.url else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Document.self, from: data)
        } catch {
            print("Failed to load autosaved document: \(error)")
            return nil
        }
    }
}
