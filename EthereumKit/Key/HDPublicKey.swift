public struct HDPublicKey {
    public let raw: Data
    public let chainCode: Data
    private let depth: UInt8
    private let fingerprint: UInt32
    private let childIndex: UInt32
    private let network: Network
    
    private let hdPrivateKey: HDPrivateKey
    
    public init(hdPrivateKey: HDPrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, childIndex: UInt32) {
        self.raw = PublicKey.from(data: hdPrivateKey.raw, compressed: true)
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.childIndex = childIndex
        self.network = network
        self.hdPrivateKey = hdPrivateKey
    }
    
    public func publicKey() -> PublicKey {
        return PublicKey(privateKey: hdPrivateKey.privateKey())
    }
    
    public func extended() -> String {
        var extendedPublicKeyData = Data()
        extendedPublicKeyData += network.publicKeyPrefix.bigEndian
        extendedPublicKeyData += depth.littleEndian
        extendedPublicKeyData += fingerprint.littleEndian
        extendedPublicKeyData += childIndex.littleEndian
        extendedPublicKeyData += chainCode
        extendedPublicKeyData += raw
        let checksum = Crypto.doubleSHA256(extendedPublicKeyData).prefix(4)
        return Base58.encode(extendedPublicKeyData + checksum)
    }
}
