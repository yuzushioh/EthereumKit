public final class Wallet {
    
    private let network: Network
    private let masterPrivateKey: PrivateKey
    
    public init(seed: Data, network: Network) {
        self.network = network
        self.masterPrivateKey = PrivateKey(seed: seed, network: network)
    }
    
    // MARK: - Public Methods
    
    public func generatePrivateKey() throws -> PrivateKey {
        return try generatePrivateKey(at: 0)
    }
    
    public func generateAddress() throws -> String {
        return try generateAddress(at: 0)
    }
    
    public func signTransaction(_ rawTransaction: RawTransaction) throws -> String? {
        let signTransaction = SignTransaction(
            rawTransaction: rawTransaction,
            gasPrice: Converter.toWei(GWei: Gas.price.value),
            gasLimit: Gas.limit.value
        )
        
        let signer = EIP155Signer(chainID: network.chainID)
        let privateKey = try generatePrivateKey()
        let rawData = try signer.sign(signTransaction, privateKey: privateKey)
        return rawData?.toHexString().appending0xPrefix
    }
    
    // MARK: - Internal Methods
    
    internal func generatePrivateKey(at index: UInt32) throws -> PrivateKey {
        return try privateKey(change: .external).derived(at: index)
    }
    
    internal func generateAddress(at index: UInt32) throws -> String {
        return try generatePrivateKey(at: index).generateAddress()
    }
    
    // MARK: - Private Methods
    
    // Ethereum only uses external.
    private enum Change: UInt32 {
        case external
    }
    
    // m/44'/coin_type'/0'/external
    private func privateKey(change: Change) throws -> PrivateKey {
        return try masterPrivateKey
            .derived(at: 44, hardens: true)
            .derived(at: network.coinType, hardens: true)
            .derived(at: 0, hardens: true)
            .derived(at: change.rawValue)
    }
}
