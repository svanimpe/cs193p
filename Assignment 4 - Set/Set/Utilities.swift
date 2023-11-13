extension Equatable {
    
    func isOneOf(_ matches: Self...) -> Bool {
        matches.contains(self)
    }
}
