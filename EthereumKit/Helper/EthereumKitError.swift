public enum EthereumKitError: Error {
    case apiClientError(APIClientError)
    case failedToSign
    case rlpFailedToEncode(Any)
    case keyDerivateionFailed
}
