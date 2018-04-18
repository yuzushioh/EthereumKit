import APIKit

public enum APIClientError: Error {
    case connectionError(Error)
    case jsonrpcError(JSONRPCError)
    case systemError(Error)
    
    init(_ error: Error) {
        switch error {
        case SessionTaskError.connectionError(let error):
            self = .connectionError(error)
            
        case let error as JSONRPCError:
            self = .jsonrpcError(error)
            
        default:
            self = .systemError(error)
        }
    }
}
