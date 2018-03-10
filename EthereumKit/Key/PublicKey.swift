public struct PublicKey {
    
    public let raw: Data
    
    public init(raw: Data) {
        self.raw = raw
    }
    
    private var addressData: Data {
        let hash = raw.dropFirst().sha3(.keccak256)
        return hash.suffix(20)
    }
    
    public func generateAddress() -> String {
        return Address(data: addressData).string
    }
}
