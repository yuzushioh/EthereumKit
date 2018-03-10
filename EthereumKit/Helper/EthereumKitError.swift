
enum EthereumKitError: Error {
    case failedToSign
    case rlpFailedToEncode(Any)
    case keyDerivateionFailed
}
