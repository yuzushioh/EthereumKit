public enum EthereumKitError: Error {
    case apiClientError(APIClientError)
    case failedToSign
    case rlpFailedToEncode(Any)
    case keyDerivateionFailed
    case other(Error)
    
    init(_ error: Error) {
        switch error {
        case let error as APIClientError:
            self = .apiClientError(error)
        default:
            self = .other(error)
        }
    }
}
