import EthereumKit.Private
import secp256k1

public final class Crypto {
    public static func HMACSHA512(key: Data, data: Data) -> Data {
        return CryptoHash.hmacsha512(data, key: key)
    }
    
    public static func PBKDF2SHA512(_ password: Data, salt: Data) -> Data {
        return PKCS5.pbkdf2(password, salt: salt, iterations: 2048, keyLength: 64)
    }
    
    public static func hash160(_ data: Data) -> Data {
        return CryptoHash.ripemd160(CryptoHash.sha256(data))
    }
    
    public static func generatePublicKey(data: Data, compressed: Bool) -> Data {
        return Secp256k1.generatePublicKey(withPrivateKey: data, compression: compressed)
    }
    
    public static func sign(_ data: Data, privateKey: Data) throws -> Data {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
        defer { secp256k1_context_destroy(context) }

        var signature = secp256k1_ecdsa_recoverable_signature()
        let status = privateKey.withUnsafeBytes { (key: UnsafePointer<UInt8>) in
            data.withUnsafeBytes { secp256k1_ecdsa_sign_recoverable(context, &signature, $0, key, nil, nil) }
        }
        
        guard status == 1 else { throw EthereumKitError.failedToSign }
        
        var output = Data(count: 65)
        var recid = 0 as Int32
        _ = output.withUnsafeMutableBytes { (output: UnsafeMutablePointer<UInt8>) in
            secp256k1_ecdsa_recoverable_signature_serialize_compact(context, output, &recid, &signature)
        }
        
        output[64] = UInt8(recid)
        
        return output
    }
}
