import SwiftUI

struct ContentView: View {
    
    @State var emojis: [String] = []
        
    var body: some View {
        VStack {
            Text("Memorize!")
                .font(.largeTitle)
            ScrollView {
                cards
            }
            HStack(alignment: .lastTextBaseline, spacing: 32) {
                Spacer()
                buttonToSelect(Theme.vehicles)
                buttonToSelect(Theme.people)
                buttonToSelect(Theme.food)
                Spacer()
            }
        }
        .padding()
        .onAppear {
            select(Theme.vehicles)
        }
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
            ForEach(emojis.indices, id: \.self) { index in
                CardView(content: emojis[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundColor(.orange)
    }
    
    func buttonToSelect(_ theme: Theme) -> some View {
        Button {
            select(theme)
        } label: {
            VStack {
                Image(systemName: theme.symbol)
                    .font(.title)
                Text(theme.name)
                    .font(.caption)
            }
        }
    }
    
    func select(_ theme: Theme) {
        emojis = theme.emojis
            .flatMap { [$0, $0] }
            .shuffled()
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        ContentView()
    }
}
