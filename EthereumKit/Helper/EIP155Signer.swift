import SMP
import CryptoSwift

public struct EIP155Signer {
    
    private let chainID: Int
    
    public init(chainID: Int) {
        self.chainID = chainID
    }
    
    public func sign(_ signTransaction: SignTransaction, privateKey: PrivateKey) throws -> Data {
        let transactionHash = try hash(signTransaction: signTransaction)
        let signiture = try privateKey.sign(hash: transactionHash)
        
        let (r, s, v) = calculateRSV(signiture: signiture)
        return try RLP.encode([
            signTransaction.nonce,
            signTransaction.gasPrice,
            signTransaction.gasLimit,
            signTransaction.to.data,
            signTransaction.value,
            signTransaction.data,
            v, r, s
        ])
    }
    
    public func hash(signTransaction: SignTransaction) throws -> Data {
        let sha3 = SHA3(variant: .keccak256)
        let data = try encode(signTransaction: signTransaction)
        return Data(bytes: sha3.calculate(for: data.bytes))
    }
    
    public func encode(signTransaction: SignTransaction) throws -> Data {
        return try RLP.encode([
            signTransaction.nonce,
            signTransaction.gasPrice,
            signTransaction.gasLimit,
            signTransaction.to.data,
            signTransaction.value,
            signTransaction.data,
            chainID, 0, 0 // EIP155
        ])
    }
    
    public func calculateRSV(signiture: Data) -> (r: Data, s: Data, v: Data) {
        return (
            r: signiture[..<32],
            s: signiture[32..<64],
            v: Data([signiture[64] + UInt8(35) + UInt8(chainID) + UInt8(chainID)])
        )
    }
}
