import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    
    private let items: [Item]
    private let aspectRatio: CGFloat
    private let content: (Item) -> ItemView
    
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemWidth = gridItemWidthThatFits(geometry.size)
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: gridItemWidth), spacing: 0)],
                spacing: 0
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
        repeat {
            let itemWidth = size.width / columnCount
            let itemHeight = itemWidth / aspectRatio
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * itemHeight < size.height {
                return itemWidth.rounded(.down)
            } else {
                columnCount += 1
            }
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}

struct AspectVGrid_Previews: PreviewProvider {
    
    struct PreviewContent: Identifiable {
        let id: String
        static let items: [Self] = (1...10).map { Self(id: "\($0)") }
    }
    
    static var previews: some View {
        AspectVGrid(PreviewContent.items, aspectRatio: 2) { item in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.yellow)
                Text(item.id)
                    .font(.headline)
            }
            .padding(4)
        }
        .padding()
    }
}
