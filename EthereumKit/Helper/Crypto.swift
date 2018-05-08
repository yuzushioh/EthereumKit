import EthereumKit.Private
import secp256k1
import CryptoSwift

/// Helper class for cryptographic algorithms.
public final class Crypto {
    /// Produces "hash-based message authentication code" that can be used to verify data integrity and authenticity.
    /// Hash is 512-bit length (64 bytes)
    ///
    /// - Parameters:
    ///   - key: secret key for signing the message
    ///   - data: message to sign
    /// - Returns: 512-bit hash-based message authentication code
    public static func HMACSHA512(key: Data, data: Data) -> Data {
        return CryptoHash.hmacsha512(data, key: key)
    }
    
    /// Derives 512-bit (64-byte) private key from a password using PBKDF2 algorithm
    ///
    /// - Parameters:
    ///   - password: password to generate private key from
    ///   - salt: random data (entropy)
    /// - Returns: private key derived from password
    public static func PBKDF2SHA512(_ password: Data, salt: Data) -> Data {
        return PKCS5.pbkdf2(password, salt: salt, iterations: 2048, keyLength: 64)
    }
    
    /// Returns 160-bit hash of the data
    ///
    /// - Parameter data: data to be hashed
    /// - Returns: hash
    public static func hash160(_ data: Data) -> Data {
        return CryptoHash.ripemd160(CryptoHash.sha256(data))
    }
    
    /// Hashes data with SHA256 twice
    ///
    /// - Parameter data: data to be hashed
    /// - Returns: hash
    public static func doubleSHA256(_ data: Data) -> Data {
        return data.sha256().sha256()
    }

    /// Returns SHA3 256-bit (32-byte) hash of the data
    ///
    /// - Parameter data: data to be hashed
    /// - Returns: 256-bit (32-byte) hash
    public static func hashSHA3_256(_ data: Data) -> Data {
        return data.sha3(.keccak256)
    }
    
    /// Generates public key from private key using secp256k1 elliptic curve math
    ///
    /// - Parameters:
    ///   - data: private key
    ///   - compressed: whether public key should be compressed
    /// - Returns: 65-byte key if not compressed, otherwise 33-byte public key.
    public static func generatePublicKey(data: Data, compressed: Bool) -> Data {
        return Secp256k1.generatePublicKey(withPrivateKey: data, compression: compressed)
    }
    
    /// Signs hash with private key
    ///
    /// - Parameters:
    ///   - hash: Hash of a message (32-byte data = 256-bit hash)
    ///   - privateKey: serialized private key based on secp256k1 algorithm
    /// - Returns: 65-byte signature of the hash data
    /// - Throws: EthereumKitError.failedToSign in case private key was invalid
    public static func sign(_ hash: Data, privateKey: Data) throws -> Data {
        let encrypter = EllipticCurveEncrypterSecp256k1()
        guard var signatureInInternalFormat = encrypter.sign(hash: hash, privateKey: privateKey) else { throw EthereumKitError.cryptoError(.failedToSign) }
        return encrypter.export(signature: &signatureInInternalFormat)
    }

    /// Validates a signature of a hash with publicKey. If valid, it guarantees that the hash was signed by the
    /// publicKey's private key.
    ///
    /// - Parameters:
    ///   - signature: hash's signature (65-byte)
    ///   - hash: 32-byte (256-bit) hash of a message
    ///   - publicKey: public key data in either compressed (then it is 33 bytes) or uncompressed (65 bytes) form
    ///   - compressed: whether public key is compressed
    /// - Returns: True, if signature is valid for the hash and public key, false otherwise.
    public static func isValid(signature: Data, of hash: Data, publicKey: Data, compressed: Bool) -> Bool {
        guard let recoveredPublicKey = self.publicKey(signature: signature, of: hash, compressed: compressed) else { return false }
        return recoveredPublicKey == publicKey
    }

    /// Calculates public key by a signature of a hash.
    ///
    /// - Parameters:
    ///   - signature: hash's signature (65-byte)
    ///   - hash: 32-byte (256-bit) hash of a message
    ///   - compressed: whether public key is compressed
    /// - Returns: 65-byte key if not compressed, otherwise 33-byte public key.
    public static func publicKey(signature: Data, of hash: Data, compressed: Bool) -> Data? {
        let encrypter = EllipticCurveEncrypterSecp256k1()
        var signatureInInternalFormat = encrypter.import(signature: signature)
        guard var publicKeyInInternalFormat = encrypter.publicKey(signature: &signatureInInternalFormat, hash: hash) else { return nil }
        return encrypter.export(publicKey: &publicKeyInInternalFormat, compressed: compressed)
    }

}
