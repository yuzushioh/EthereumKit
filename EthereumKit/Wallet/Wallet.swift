public final class Wallet {
    
    private let network: Network
    private let privateKey: PrivateKey
    
    public init(seed: Data, network: Network) throws {
        self.network = network
        
        // m/44'/coin_type'/0'/external
        let externalPrivateKey = try HDPrivateKey(seed: seed, network: network)
            .derived(at: 44, hardens: true)
            .derived(at: network.coinType, hardens: true)
            .derived(at: 0, hardens: true)
            .derived(at: 0) // 0 for external
        
        privateKey = try externalPrivateKey
            .derived(at: 0)
            .privateKey()
    }
    
    public init(network: Network, privateKey: String) {
        self.network = network
        self.privateKey = PrivateKey(raw: Data(hex: privateKey))
    }
    
    // MARK: - Public Methods
    
    public func generateAddress() -> String {
        return privateKey.publicKey.generateAddress()
    }
    
    public func dumpPrivateKey() -> String {
        return privateKey.raw.toHexString()
    }
    
    public func signTransaction(_ rawTransaction: RawTransaction) throws -> String {
        let signTransaction = SignTransaction(
            rawTransaction: rawTransaction,
            gasPrice: Converter.toWei(GWei: Gas.price.value),
            gasLimit: Gas.limit.value
        )
        let signer = EIP155Signer(chainID: network.chainID)
        let rawData = try signer.sign(signTransaction, privateKey: privateKey)
        return rawData.toHexString().appending0xPrefix
    }
}
