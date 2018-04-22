import EthereumKit.Private

public struct PrivateKey {
    public let raw: Data
    
    public init(raw: Data) {
        self.raw = raw
    }
    
    public var publicKey: PublicKey {
        return PublicKey(privateKey: self)
    }
    
    public func sign(hash: Data) throws -> Data {
        return try Crypto.sign(hash, privateKey: raw)
    }
}
