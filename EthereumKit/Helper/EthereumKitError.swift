public enum EthereumKitError: Error {
    
    public enum RequestError: Error {
        case invalidURL
        case invalidParameters(Any)
    }
    
    public enum ResponseError: Error {
        case jsonrpcError(JSONRPCError)
        case connectionError(Error)
        case unexpected(Error)
        case unacceptableStatusCode(Int)
        case noContentProvided
    }
    
    public enum CryptoError: Error {
        case failedToSign
        case failedToEncode(Any)
        case keyDerivateionFailed
    }
    
    case requestError(RequestError)
    case responseError(ResponseError)
    case cryptoError(CryptoError)
}
