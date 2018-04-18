import APIKit

public enum APIClientError: Error {
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
