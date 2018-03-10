import EthereumKit.Private

public struct PrivateKey {
    public let raw: Data
    
    public init(raw: Data) {
        self.raw = raw
    }
    
    public var publicKey: PublicKey {
        return PublicKey(raw: Crypto.generatePublicKey(data: raw, compressed: false))
    }
    
    public func sign(hash: Data) throws -> Data {
        return try Crypto.sign(hash, privateKey: raw)
    }
}
