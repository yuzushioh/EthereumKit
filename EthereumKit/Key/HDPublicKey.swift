public struct HDPublicKey {
    public let raw: Data
    public let chainCode: Data
    private let depth: UInt8
    private let fingerprint: UInt32
    private let index: UInt32
    private let network: Network
    
    private let hdPrivateKey: HDPrivateKey
    
    public init(hdPrivateKey: HDPrivateKey, chainCode: Data, network: Network, depth: UInt8, fingerprint: UInt32, index: UInt32) {
        self.raw = Data(hex: "0x") + PublicKey.from(data: hdPrivateKey.raw, compressed: true)
        self.chainCode = chainCode
        self.depth = depth
        self.fingerprint = fingerprint
        self.index = index
        self.network = network
        self.hdPrivateKey = hdPrivateKey
    }
    
    public func publicKey() -> PublicKey {
        return PublicKey(privateKey: hdPrivateKey.privateKey())
    }
}
