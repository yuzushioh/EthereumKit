import APIKit

// TODO: Handle jsonrpc error
public enum GethError: Error {
    case connectionError(Error)
    case systemError(Error)
    
    init(_ error: Error) {
        switch error {
        case SessionTaskError.connectionError(let error):
            self = .connectionError(error)
            
        default:
            self = .systemError(error)
        }
    }
}
