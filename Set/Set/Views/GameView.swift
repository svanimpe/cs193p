import SwiftUI

struct GameView: View {
    
    // The view model should be a @StateObject or @EnvironmentObject,
    // but those aren't covered yet in the lectures.
    @ObservedObject var vm = ViewModel()
    
    let theme = Theme()
    
    @Namespace private var cards
    
    var body: some View {
        VStack(spacing: 16) {
            AspectRatioVGrid(vm.cards, aspectRatio: 2/3, spacing: 10) { card in
                theme.view(for: card)
                    .matchedGeometryEffect(id: card.id, in: cards)
                    .onTapGesture {
                        withAnimation {
                            vm.select(card)
                        }
                    }
                    .scaleEffect(card.status == .mismatched ? CGSize(width: 0.8, height: 0.8) : CGSize(width: 1, height: 1))
                    .rotationEffect(card.status == .matched ? .degrees(360) : .degrees(0))
                    .animation(.easeInOut, value: card.status)
            }
            HStack {
                deck
                Spacer()
                reset
                Spacer()
                discards
            }
            .padding(.horizontal, 16)
        }
        .padding(16)
    }
    
    private var deck: some View {
        VStack {
            ZStack {
                theme.emptyDeckView
                ForEach(vm.deck) { card in
                    theme.backView
                        .matchedGeometryEffect(id: card.id, in: cards)
                }
            }
            .frame(width: 40, height: 60)
            .onTapGesture {
                withAnimation {
                    vm.drawCards()
                }
            }
            .disabled(vm.deck.isEmpty)
            Text("Deck")
        }
    }
    
    private var reset: some View {
        Button {
            withAnimation {
                vm.reset()
            }
        } label: {
            VStack {
                Image(systemName: "arrow.clockwise")
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
    }
    
    private var discards: some View {
        VStack {
            ZStack {
                theme.emptyDiscardsView
                ForEach(vm.discards) { card in
                    theme.view(for: card, discarded: true)
                        .matchedGeometryEffect(id: card.id, in: cards)
                }
            }
            .frame(width: 40, height: 60)
            Text("Discards")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        GameView()
    }
}
