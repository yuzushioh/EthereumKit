public final class HDWallet {
    
    private let masterPrivateKey: HDPrivateKey
    private let network: Network
    
    public init(seed: Data, network: Network) {
        self.masterPrivateKey = HDPrivateKey(seed: seed, network: network)
        self.network = network
    }
    
    // MARK: - Public Methods
    
    public func privateKey(at index: UInt32) throws -> PrivateKey {
        return try privateKey(change: .external).derived(at: index).privateKey()
    }
    
    public func address(at index: UInt32) throws -> String {
        return try privateKey(at: index).publicKey.address()
    }
    
    public func privateKey(at index: UInt32) throws -> String {
        return try privateKey(at: index).raw.toHexString()
    }
    
    // MARK: - Private Methods
    
    // Ethereum only uses external.
    private enum Change: UInt32 {
        case external = 0
        case `internal` = 1
    }
    
    // m/44'/coin_type'/0'/external
    private func privateKey(change: Change) throws -> HDPrivateKey {
        return try masterPrivateKey
            .derived(at: 44, hardens: true)
            .derived(at: network.coinType, hardens: true)
            .derived(at: 0, hardens: true)
            .derived(at: change.rawValue)
    }
}

// MARK: - Sign Transaction

extension HDWallet {
    
    /// Sign signs rlp encoding hash of specified raw transaction
    ///
    /// - Parameters:
    ///   - rawTransaction: raw transaction to hash
    ///   - index: index of a private key which will be used to sign
    /// - Returns: signiture in hex format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func sign(rawTransaction: RawTransaction, withPrivateKeyAtIndex index: UInt32) throws -> String {
        let wallet = Wallet(network: network, privateKey: try privateKey(at: index), debugPrints: false)
        return try wallet.sign(rawTransaction: rawTransaction)
    }
}

// MARK :- Sign message

extension HDWallet {
    
    /// Sign a provided hex string
    ///
    /// - Parameters:
    ///   - hex: hex value to sign (hex format)
    ///   - index: index of a private key which will be used to sign
    /// - Returns: signature in string format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func sign(hex: String, withPrivateKeyAtIndex index: UInt32) throws -> String {
        let wallet = Wallet(network: network, privateKey: try privateKey(at: index), debugPrints: false)
        return try wallet.sign(hex: hex)
    }
    
    /// Sign a provided message
    ///
    /// - Parameters:
    ///   - message: message to sign (string format)
    ///   - index: index of a private key which will be used to sign
    /// - Returns: signature in string format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func sign(message: String, withPrivateKeyAtIndex index: UInt32) throws -> String {
        let wallet = Wallet(network: network, privateKey: try privateKey(at: index), debugPrints: false)
        return try wallet.sign(message: message)
    }
}

extension HDWallet {
    
    /// Sign calculates an Ethereum ECDSA signature for: keccack256("\x19Ethereum Signed Message:\n" + len(message) + message))
    /// See also: https://github.com/ethereum/go-ethereum/wiki/Management-APIs#personal_sign
    ///
    /// - Parameters:
    ///   - hex: message in hex format to sign
    ///   - index: index of a private key which will be used to sign
    /// - Returns: signiture in hex format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func personalSign(hex: String, withPrivateKeyAtIndex index: UInt32) throws -> String {
        let wallet = Wallet(network: network, privateKey: try privateKey(at: index), debugPrints: false)
        return try wallet.personalSign(hex: hex)
    }
    
    /// Sign calculates an Ethereum ECDSA signature for: keccack256("\x19Ethereum Signed Message:\n" + len(message) + message))
    /// See also: https://github.com/ethereum/go-ethereum/wiki/Management-APIs#personal_sign
    ///
    /// - Parameters:
    ///   - message: message to sign
    ///   - index: index of a private key which will be used to sign
    /// - Returns: signiture in hex format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func personalSign(message: String, withPrivateKeyAtIndex index: UInt32) throws -> String {
        let wallet = Wallet(network: network, privateKey: try privateKey(at: index), debugPrints: false)
        return try wallet.personalSign(message: message)
    }
}
