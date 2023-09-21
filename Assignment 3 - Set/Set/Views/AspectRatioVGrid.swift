import SwiftUI

// A LazyVGrid that holds elements with a fixed aspect ratio.
// This is an improved implementation that supports spacing between the elements.
struct AspectRatioVGrid<Item: Identifiable, ItemView: View>: View {
    
    private let items: [Item]
    private let aspectRatio: CGFloat
    private let spacing: CGFloat
    private let content: (Item) -> ItemView
        
    init(
        _ items: [Item],
        aspectRatio: CGFloat,
        spacing: CGFloat,
        @ViewBuilder content: @escaping (Item) -> ItemView
    ) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemWidth: CGFloat = gridItemWidthThatFits(geometry.size)
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: gridItemWidth), spacing: spacing)],
                spacing: spacing
            ) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }
    
    private func gridItemWidthThatFits(_ size: CGSize) -> CGFloat {
        let count = CGFloat(items.count)
        var columnCount = 1.0
        while columnCount < count {
            let availableWidth = size.width - (columnCount - 1) * spacing
            let itemWidth = availableWidth / columnCount
            let itemHeight = itemWidth / aspectRatio
            let rowCount = (count / columnCount).rounded(.up)
            let totalHeight = rowCount * itemHeight + (rowCount - 1) * spacing
            if totalHeight <= size.height {
                break // We found the ideal size.
            } else {
                columnCount += 1
            }
        }
        let availableWidth = size.width - (columnCount - 1) * spacing
        return min(
            availableWidth / columnCount,
            size.height * aspectRatio
        ).rounded(.down)
    }
}

struct AspectRatioVGrid_Previews: PreviewProvider {
    
    struct PreviewContent: Identifiable {
        let id: String
        static let items: [Self] = (1...20).map { .init(id: "\($0)") }
    }
    
    static var previews: some View {
        AspectRatioVGrid(PreviewContent.items, aspectRatio: 2/3, spacing: 8) { item in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.yellow)
                Text(item.id)
                    .font(.headline)
            }
        }
        .padding()
    }
}
