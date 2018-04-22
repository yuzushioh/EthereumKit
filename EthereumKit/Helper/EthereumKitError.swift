public enum EthereumKitError: Error {
    case apiClientError(APIClientError)
    case failedToSign
    case failedToEncode(Any)
    case keyDerivateionFailed
}
