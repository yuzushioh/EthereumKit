import SMP
import CryptoSwift

public struct EIP155Signer {
    
    private let chainID: Int
    
    public init(chainID: Int) {
        self.chainID = chainID
    }
    
    public func sign(_ signTransaction: SignTransaction, privateKey: PrivateKey) throws -> Data? {
        guard let transactionHash = hash(signTransaction: signTransaction) else {
            return nil
        }
        
        let signiture = try privateKey.sign(hash: transactionHash)
        let (r, s, v) = calculateRSV(signiture: signiture)
        let signedData = RLP.encode([
            signTransaction.nonce,
            signTransaction.gasPrice,
            signTransaction.gasLimit,
            signTransaction.to.data,
            signTransaction.value,
            signTransaction.data,
            v, r, s
        ])
        
        return signedData
    }
    
    public func hash(signTransaction: SignTransaction) -> Data? {
        guard let data = encode(signTransaction: signTransaction) else {
            return nil
        }
        return Data(bytes: SHA3(variant: .keccak256).calculate(for: data.bytes))
    }
    
    public func encode(signTransaction: SignTransaction) -> Data? {
        return RLP.encode([
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
