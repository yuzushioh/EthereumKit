public struct PublicKey {
    
    public let raw: Data
    
    public init(raw: Data) {
        self.raw = raw
    }
    
    public init(privateKey: PrivateKey) {
        self.init(raw: Data(hex: "0x") + PublicKey.from(data: privateKey.raw, compressed: false))
    }
    
    private var addressData: Data {
        return Crypto.hashSHA3256(raw.dropFirst()).suffix(20)
    }
    
    public func generateAddress() -> String {
        return Address(data: addressData).string
    }
    
    public static func from(data: Data, compressed: Bool) -> Data {
        return Crypto.generatePublicKey(data: data, compressed: compressed)
    }
}
