import CryptoSwift

public struct EIP155Signer {
    
    private let chainID: Int
    
    public init(chainID: Int) {
        self.chainID = chainID
    }
    
    public func sign(_ rawTransaction: RawTransaction, privateKey: PrivateKey) throws -> Data {
        let transactionHash = try hash(rawTransaction: rawTransaction)
        let signiture = try privateKey.sign(hash: transactionHash)
        
        let (r, s, v) = calculateRSV(signiture: signiture)
        return try RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
    }
    
    public func hash(rawTransaction: RawTransaction) throws -> Data {
        return Crypto.hashSHA3_256(try encode(rawTransaction: rawTransaction))
    }
    
    public func encode(rawTransaction: RawTransaction) throws -> Data {
        return try RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            chainID, 0, 0 // EIP155
        ])
    }
    
    public func calculateRSV(signiture: Data) -> (r: BInt, s: BInt, v: BInt) {
        return (
            r: BInt(str: signiture[..<32].toHexString(), radix: 16)!,
            s: BInt(str: signiture[32..<64].toHexString(), radix: 16)!,
            v: BInt(signiture[64]) + BInt(35) + BInt(chainID) + BInt(chainID)
        )
    }

    public func calculateSignature(r: BInt, s: BInt, v: BInt) -> Data {
        let sigHexStr = r.asString(withBase: 16) + s.asString(withBase: 16) + (v - BInt(35) - BInt(chainID) - BInt(chainID)).asString(withBase: 16)
        return Data(hex: sigHexStr)
    }
}
