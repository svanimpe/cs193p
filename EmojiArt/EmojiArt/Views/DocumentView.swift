import SwiftUI

struct DocumentView: View {
    
    @StateObject private var document = DocumentViewModel()
    @State private var selectedEmojis: Set<UUID> = []
    @State private var isShowingError = false
    
    // MARK: - Views
    
    var body: some View {
        VStack(spacing: 0) {
            drawing
            PaletteChooser()
        }
        .task {
            await document.fetchBackgroundImage()
        }
    }
    
    private var drawing: some View {
        GeometryReader { geometry in
            ZStack {
                background(in: geometry)
                    .scaleEffect(zoomScale)
                    .position(.zero.fromDocumentCoordinates(in: geometry, scale: zoomScale, offset: offset))
                if document.backgroundFetchStatus == .loading {
                    Color.white.overlay {
                        ProgressView("Loading background...")
                    }
                } else {
                    ForEach(document.emojis) {
                        view(for: $0, in: geometry)
                    }
                }
            }
            .clipped()
            .onDrop(of: [.image, .url, .plainText], isTargeted: nil) {
                handleDrop($0, at: $1, in: geometry)
            }
            .gesture(zoom.simultaneously(with: pan))
            .alert(Text("Invalid URL"), isPresented: $isShowingError) {
                Button("OK") {
                    document.backgroundFetchStatus = .idle
                }
            } message: {
                Text("Failed to load an image from this URL.")
            }
            .onChange(of: document.backgroundFetchStatus) { status in
                if status == .failed {
                    isShowingError = true
                }
            }
        }
    }
    
    private func background(in geometry: GeometryProxy) -> some View {
        Group {
            if let image = document.backgroundImage {
                Color.white.overlay {
                    Image(uiImage: image)
                }
            } else {
                Color.white
            }
        }
        .gesture(zoomToFit(in: geometry.size).exclusively(before: deselectEmojis))
    }
    
    private func view(for emoji: Emoji, in geometry: GeometryProxy) -> some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 1 / zoomScale)
                .frame(
                    width: size(for: emoji).total + 10 / zoomScale,
                    height: size(for: emoji).total + 10 / zoomScale
                )
                .scaleEffect(zoomScale)
                .position(position(for: emoji, in: geometry))
                .foregroundColor(.red)
                .opacity(selectedEmojis.contains(emoji.id) ? 1 : 0)
            Text(emoji.text)
                .scaleEffect(zoomScale * size(for: emoji).scale)
                .position(position(for: emoji, in: geometry))
                .font(.system(size: size(for: emoji).fontSize))
        }
        .gesture(
            select(emoji)
                .exclusively(before: dragEmojis)
                .exclusively(before: remove(emoji))
        )
    }
    
    // MARK: - Gesture state and related functions
    
    @State private var baseZoomScale = 1.0 // Applies to the entire drawing
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        baseZoomScale * (selectedEmojis.isEmpty ? gestureZoomScale : 1)
    }
    
    private func size(for emoji: Emoji) -> (total: CGFloat, fontSize: CGFloat, scale: CGFloat) {
        let isSelected = selectedEmojis.contains(emoji.id)
        let totalSize = CGFloat(emoji.size) * (isSelected ? gestureZoomScale : 1)
        // Large fonts can get clipped, so we set an upper limit (in this case: 700)
        // and resort to scaling for emojis larger than this upper limit.
        if totalSize > 700 {
            return (totalSize, 700, totalSize / 700)
        } else {
            return (totalSize, totalSize, 1)
        }
    }
    
    @State private var baseOffset = CGSize.zero // Applies to the entire drawing
    @GestureState private var gestureOffset = CGSize.zero // Applies to the entire drawing
    @GestureState private var emojiOffset = CGSize.zero // Only applies to emojis being dragged
    
    private var offset: CGSize {
        (baseOffset + gestureOffset) * zoomScale
    }
    
    private func position(for emoji: Emoji, in geometry: GeometryProxy) -> CGPoint {
        let isSelected = selectedEmojis.contains(emoji.id)
        return CGPoint(
            x: emoji.x + (isSelected ? Int(emojiOffset.width) : 0),
            y: emoji.y + (isSelected ? Int(emojiOffset.height) : 0)
        ).fromDocumentCoordinates(in: geometry, scale: zoomScale, offset: offset)
    }
    
    // MARK: - Gestures
    
    private func select(_ emoji: Emoji) -> some Gesture {
        TapGesture().onEnded {
            withAnimation {
                if selectedEmojis.contains(emoji.id) {
                    selectedEmojis.remove(emoji.id)
                } else {
                    selectedEmojis.insert(emoji.id)
                }
            }
        }
    }
    
    private func remove(_ emoji: Emoji) -> some Gesture {
        LongPressGesture().onEnded { _ in
            withAnimation {
                document.remove(emoji)
            }
        }
    }
    
    private var dragEmojis: some Gesture {
        DragGesture()
            .updating($emojiOffset) { newValue, emojiOffset, _ in
                emojiOffset = newValue.translation / zoomScale
            }
            .onEnded { newValue in
                document.emojis.filter {
                    selectedEmojis.contains($0.id)
                }.forEach {
                    document.move($0, by: newValue.translation / zoomScale)
                }
            }
    }
    
    private var deselectEmojis: some Gesture {
        TapGesture().onEnded {
            withAnimation {
                selectedEmojis = []
            }
        }
    }
    
    private var pan: some Gesture {
        DragGesture()
            .updating($gestureOffset) { newValue, gestureOffset, _ in
                gestureOffset = newValue.translation / zoomScale
            }
            .onEnded { newValue in
                baseOffset += newValue.translation / zoomScale
            }
    }
    
    private var zoom: some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { newValue, gestureZoomScale, _ in
                gestureZoomScale = newValue
            }
            .onEnded { newValue in
                if selectedEmojis.isEmpty {
                    baseZoomScale *= newValue
                } else {
                    document.emojis.filter {
                        selectedEmojis.contains($0.id)
                    }.forEach {
                        document.zoom($0, scale: newValue)
                    }
                }
            }
    }
    
    private func zoomToFit(in size: CGSize) -> some Gesture {
        TapGesture(count: 2).onEnded {
            guard let image = document.backgroundImage else {
                return
            }
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            withAnimation {
                baseOffset = .zero
                baseZoomScale = min(hZoom, vZoom)
            }
        }
    }
    
    private func handleDrop(_ providers: [NSItemProvider], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for provider in providers {
            if provider.canLoadObject(ofClass: UIImage.self) {
                _ = provider.loadObject(ofClass: UIImage.self) { image, error in
                    // I'm not sure why this cast is required. UIImage does conform to NSItemProviderReading,
                    // but without the cast, the compiler thinks we're calling a different loadObject method.
                    if let image = image as? UIImage, let data = image.jpegData(compressionQuality: 1) {
                        Task {
                            await document.setBackground(.data(data))
                        }
                    }
                }
            } else if provider.canLoadObject(ofClass: URL.self) {
                _ = provider.loadObject(ofClass: URL.self) { url, error in
                    if let url {
                        Task {
                            await document.setBackground(.url(url))
                        }
                    }
                }
            } else if provider.canLoadObject(ofClass: String.self) {
                _ = provider.loadObject(ofClass: String.self) { emoji, error in
                    if let emoji {
                        let location = location.toDocumentCoordinates(in: geometry, scale: zoomScale, offset: offset)
                        Task {
                            document.addEmoji(
                                text: emoji,
                                x: location.x,
                                y: location.y,
                                size: PaletteChooser.defaultEmojiSize / zoomScale
                            )
                        }
                    }
                }
            }
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
