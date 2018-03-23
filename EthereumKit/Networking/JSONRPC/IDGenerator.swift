public struct IDGenerator {
    private var currentId = 1
    
    public mutating func next() -> Int {
        defer { currentId += 1 }
        return currentId
    }
}
