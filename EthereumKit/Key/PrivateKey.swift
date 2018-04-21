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
    
    public func sign(message: String) throws -> Data {
        let signingMessage = "\\x19Ethereum Signed Message:\n" + String(message.count) + message
        let hash = Crypto.hashSHA3_256(signingMessage.decomposedStringWithCompatibilityMapping.data(using: .utf8)!)
        return try sign(hash: hash)
    }
}
