import SwiftUI

struct FlyingNumber: View {
    
    let number: Int
    
    @State private var offset: CGFloat = 0
    
    init(_ number: Int) {
        self.number = number
    }
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .foregroundColor(number < 0 ? .red : .green)
                .shadow(
                    color: .black,
                    radius: Constants.Shadow.radius,
                    x: Constants.Shadow.xOffset,
                    y: Constants.Shadow.yOffset
                )
                .offset(y: offset)
                .opacity(offset == 0 ? 1 : 0)
                .onAppear {
                    withAnimation(.easeIn(duration: Constants.duration)) {
                        offset = number < 0 ? Constants.offset : -Constants.offset
                    }
                }
                .onDisappear {
                    offset = 0
                }
        }
    }
}

extension FlyingNumber {
    
    private enum Constants {
        
        static let offset: CGFloat = 200
        static let duration: Double = 1.5
        
        enum Shadow {
            static let radius: CGFloat = 1.5
            static let xOffset: CGFloat = 1
            static let yOffset: CGFloat = 1
        }
    }
}

struct FlyingNumber_Previews: PreviewProvider {
    static var previews: some View {
        FlyingNumber(2)
    }
}
