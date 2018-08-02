/// Wallet handles all the logic necessary for storing keys
public final class Wallet {
    
    /// Network which this wallet is connecting to
    /// Basiclly Mainnet or Ropsten
    private let network: Network
    
    /// Private key which this wallet mainly use.
    /// This is either provided by user or generated from HD wallet.
    /// for HD wallet, path is m/44'/coin_type'/0'/0
    private let key: PrivateKey
    
    /// Represents a flag whether to print a debug log.
    private let debugPrints: Bool
    
    public init(seed: Data, network: Network, debugPrints: Bool) throws {
        self.network = network
        self.debugPrints = debugPrints
        
        // m/44'/coin_type'/0'/external
        let externalPrivateKey = try HDPrivateKey(seed: seed, network: network)
            .derived(at: 44, hardens: true)
            .derived(at: network.coinType, hardens: true)
            .derived(at: 0, hardens: true)
            .derived(at: 0) // 0 for external
        
        key = try externalPrivateKey
            .derived(at: 0)
            .privateKey()
        
        if debugPrints {
            printDebugInformation()
        }
    }
    
    public init(network: Network, privateKey: String, debugPrints: Bool) {
        self.network = network
        self.key = PrivateKey(raw: Data(hex: privateKey))
        self.debugPrints = debugPrints
        
        if debugPrints {
            printDebugInformation()
        }
    }
    
    /// Generate a hash for eth_personal_sign
    ///
    /// - Parameter hex: message in hex format
    /// - Returns: hash of a message
    private func generatePersonalMessageHash(hex: String) -> Data {
        let prefix = "\u{19}Ethereum Signed Message:\n"
        let messageData = Data(hex: hex.stripHexPrefix())
        let prefixData = (prefix + String(messageData.count)).data(using: .ascii)!
        return Crypto.hashSHA3_256(prefixData + messageData)
    }
    
    private func printDebugInformation() {
        print(
            """
            \nUsing \(network) network
            PrivateKey is \(privateKey().toHexString())
            PublicKey is \(publicKey().toHexString())
            Address is \(address()) \n
            """
        )
    }
}

// MARK :- Keys

extension Wallet {
    
    /// Generates address from main private key.
    ///
    /// - Returns: Address in string format
    public func address() -> String {
        return key.publicKey.address()
    }
    
    /// Reveal private key of this wallet in data format
    ///
    /// - Returns: Private key in data format
    public func privateKey() -> Data {
        return key.raw
    }
    
    /// Reveal public key of this wallet in data format
    ///
    /// - Returns: Public key in data format
    public func publicKey() -> Data {
        return key.publicKey.raw
    }
}

// MARK: - Sign Transaction

extension Wallet {
    
    /// Sign signs rlp encoding hash of specified raw transaction
    ///
    /// - Parameter rawTransaction: raw transaction to hash
    /// - Returns: signiture in hex format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func sign(rawTransaction: RawTransaction) throws -> String {
        let signer = EIP155Signer(chainID: network.chainID)
        let rawData = try signer.sign(rawTransaction, privateKey: key)
        let hash = rawData.toHexString().addHexPrefix()
        if debugPrints {
            print(
                """
                \nSigning \(rawTransaction)
                Raw tx hash is \(hash) \n
                """
            )
        }
        return hash
    }
}

// MARK :- Sign message

extension Wallet {
    
    /// Sign a provided hex
    ///
    /// - Parameter hex: hex value to sign (hex format)
    /// - Returns: signature in string format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func sign(hex: String) throws -> String {
        let hash = Crypto.hashSHA3_256(Data(hex: hex.stripHexPrefix()))
        return try key.sign(hash: hash).toHexString()
    }
    
    /// Sign a provided message
    ///
    /// - Parameter message: message to sign (string format)
    /// - Returns: signature in string format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func sign(message: String) throws -> String {
        return try sign(hex: message.toHexString())
    }
}

// MARK :- Personal-sign message

extension Wallet {
    
    /// Sign calculates an Ethereum ECDSA signature for: keccack256("\x19Ethereum Signed Message:\n" + len(message) + message))
    /// See also: https://github.com/ethereum/go-ethereum/wiki/Management-APIs#personal_sign
    ///
    /// - Parameter hex: message in hex format to sign
    /// - Returns: signiture in hex format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func personalSign(hex: String) throws -> String {
        let hash = generatePersonalMessageHash(hex: hex)
        var signiture = try key.sign(hash: hash)
        
        // Note, the produced signature conforms to the secp256k1 curve R, S and V values,
        // where the V value will be 27 or 28 for legacy reasons.
        signiture[64] += 27
        
        let signedHash = signiture.toHexString().addHexPrefix()
        if debugPrints {
            print(
                """
                \nSigning \(hex)
                Message hash is \(signedHash) \n
                """
            )
        }
        return signedHash
    }
    
    /// Sign calculates an Ethereum ECDSA signature for: keccack256("\x19Ethereum Signed Message:\n" + len(message) + message))
    /// See also: https://github.com/ethereum/go-ethereum/wiki/Management-APIs#personal_sign
    ///
    /// - Parameter hex: message to sign
    /// - Returns: signiture in hex format
    /// - Throws: EthereumKitError.failedToEncode when failed to encode
    public func personalSign(message: String) throws -> String {
        return try personalSign(hex: message.toHexString())
    }
}

// MARK :- Validate signature

extension Wallet {
    
    /// Verify a personal_signed signature
    ///
    /// - Parameters:
    ///   - signature: signature in string format, must be signed with eth_personal_sign
    ///   - message: message you signed
    ///   - compressed: whether a public key is compressed
    /// - Returns: whether a signature is valid or not
    public func verify(personalSigned signature: String, message: String, compressed: Bool = false) -> Bool {
        var sig = Data(hex: signature)
        
        if sig[64] != 27 && sig[64] != 28 {
            fatalError()
        }
        
        sig[64] = sig[64] - 27
        
        let hash = generatePersonalMessageHash(hex: message.toHexString())
        return verifySignature(signature: sig, hash: hash, compressed: compressed)
    }
    
    /// Verify a signature
    ///
    /// - Parameters:
    ///   - signature: signature in data format
    ///   - hash: hash of an message you signed
    ///   - compressed: whether a public key is compressed
    /// - Returns: whether a signature is valid or not
    public func verify(normalSigned signature: String, message: String, compressed: Bool = false) -> Bool {
        let hash = Crypto.hashSHA3_256(Data(hex: message.toHexString().stripHexPrefix()))
        return verifySignature(signature: Data(hex: signature), hash: hash, compressed: compressed)
    }
    
    private func verifySignature(signature: Data, hash: Data, compressed: Bool) -> Bool {
        return Crypto.isValid(signature: signature, of: hash, publicKey: publicKey(), compressed: compressed)
    }
}
