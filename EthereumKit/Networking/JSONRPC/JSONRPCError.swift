public enum JSONRPCError: Error {
    case responseError(code: Int, message: String, data: Any?)
    case responseNotFound(requestId: Int, object: Any)
    case resultObjectParseError(Error)
    case errorObjectParseError(Error)
    case unsupportedVersion(String?)
    case unexpectedTypeObject(Any)
    case missingBothResultAndError(Any)
    
    public init(errorObject: Any) {
        enum ParseError: Error {
            case nonDictionaryObject(object: Any)
            case missingKey(key: String, errorObject: Any)
        }
        
        do {
            guard let dictionary = errorObject as? [String: Any] else {
                throw ParseError.nonDictionaryObject(object: errorObject)
            }
            
            guard let code = dictionary["code"] as? Int else {
                throw ParseError.missingKey(key: "code", errorObject: errorObject)
            }
            
            guard let message = dictionary["message"] as? String else {
                throw ParseError.missingKey(key: "message", errorObject: errorObject)
            }
            
            self = .responseError(code: code, message: message, data: dictionary["data"])
        } catch {
            self = .errorObjectParseError(error)
        }
    }
}

