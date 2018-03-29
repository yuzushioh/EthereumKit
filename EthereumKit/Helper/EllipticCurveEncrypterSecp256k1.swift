import secp256k1
import Foundation

/// Convenience class over libsecp256k1 methods
final class EllipticCurveEncrypterSecp256k1 {
    // holds internal state of the c library
    private let context: OpaquePointer

    init() {
        context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))!
    }

    deinit {
        secp256k1_context_destroy(context)
    }

    /// Signs the hash with the private key. Produces signature data structure that can be exported with
    /// export(signature:) method.
    ///
    /// - Parameters:
    ///   - hash: 32-byte (256-bit) hash of the message
    ///   - privateKey: 32-byte private key
    /// - Returns: signature data structure if signing succeeded, otherwise nil.
    func sign(hash: Data, privateKey: Data) -> secp256k1_ecdsa_recoverable_signature? {
        precondition(hash.count == 32, "Hash must be 32 bytes size")
        var signature = secp256k1_ecdsa_recoverable_signature()
        let status = privateKey.withUnsafeBytes { (key: UnsafePointer<UInt8>) in
            hash.withUnsafeBytes { secp256k1_ecdsa_sign_recoverable(context, &signature, $0, key, nil, nil) }
        }
        return status == 1 ? signature : nil
    }

    /// Converts signature data structure to 65 bytes.
    ///
    /// - Parameter signature: signature data structure
    /// - Returns: 65 byte exported signature data.
    func export(signature: inout secp256k1_ecdsa_recoverable_signature) -> Data {
        var output = Data(count: 65)
        var recid = 0 as Int32
        _ = output.withUnsafeMutableBytes { (output: UnsafeMutablePointer<UInt8>) in
            secp256k1_ecdsa_recoverable_signature_serialize_compact(context, output, &recid, &signature)
        }

        output[64] = UInt8(recid)
        return output
    }

    /// Converts serialized signature into library's signature format. Use it to supply signature to
    /// the publicKey(signature:hash:) method.
    ///
    /// - Parameter signature: serialized 65-byte signature
    /// - Returns: signature structure
    func `import`(signature: Data) -> secp256k1_ecdsa_recoverable_signature {
        precondition(signature.count == 65, "Signature must be 65 byte size")
        var sig = secp256k1_ecdsa_recoverable_signature()
        let recid = Int32(signature[64])
        signature.withUnsafeBytes { (input: UnsafePointer<UInt8>) -> Void in
            secp256k1_ecdsa_recoverable_signature_parse_compact(context, &sig, input, recid)
        }
        return sig
    }

    /// Recovers public key from the signature and the hash. Use import(signature:) to convert signature from bytes.
    /// Use export(publicKey:compressed) to convert recovered public key into bytes.
    ///
    /// - Parameters:
    ///   - signature: signature structure
    ///   - hash: 32-byte (256-bit) hash of a message
    /// - Returns: public key structure or nil, if signature invalid
    func publicKey(signature: inout secp256k1_ecdsa_recoverable_signature, hash: Data) -> secp256k1_pubkey? {
        precondition(hash.count == 32, "Hash must be 32 bytes size")
        let hash = hash.bytes
        var outPubKey = secp256k1_pubkey()
        let status = secp256k1_ecdsa_recover(context, &outPubKey, &signature, hash)
        return status == 1 ? outPubKey : nil
    }

    /// Converts public key from library's data structure to bytes
    ///
    /// - Parameters:
    ///   - publicKey: public key structure to convert.
    ///   - compressed: whether public key should be compressed.
    /// - Returns: If compression enabled, public key is 33 bytes size, otherwise it is 65 bytes.
    func export(publicKey: inout secp256k1_pubkey, compressed: Bool) -> Data {
        var output = Data(count: compressed ? 33 : 65)
        var outputLen: Int = output.count
        let compressedFlags = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
        output.withUnsafeMutableBytes { (pointer: UnsafeMutablePointer<UInt8>) -> Void in
            secp256k1_ec_pubkey_serialize(context, pointer, &outputLen, &publicKey, compressedFlags)
        }
        return output
    }
}
