/// `JSONBodyParameters` serializes JSON object for HTTP body and states its content type is JSON.
public struct JSONBodySerialization {
    
    /// The JSON object to be serialized.
    public let object: Any
    
    /// The writing options for serialization.
    public let writingOptions: JSONSerialization.WritingOptions
    
    /// Returns `JSONBodyParameters` that is initialized with JSON object and writing options.
    public init(_ object: Any, writingOptions: JSONSerialization.WritingOptions = []) {
        self.object = object
        self.writingOptions = writingOptions
    }
    
    /// `Content-Type` to send. The value for this property will be set to `Accept` HTTP header field.
    public var contentType: String {
        return "application/json"
    }
    
    /// Builds `RequestBodyEntity.data` that represents `JSONObject`.
    /// - Throws: `NSError` if `JSONSerialization` fails to serialize `JSONObject`.
    public func build() -> Result<Data> {
        
        // If isValidJSONObject(_:) is false, dataWithJSONObject(_:options:) throws NSException.
        guard JSONSerialization.isValidJSONObject(object) else {
            return .failure(EthereumKitError.requestError(.invalidParameters(object)))
        }
        
        let data: Data
        do {
            data = try JSONSerialization.data(withJSONObject: object, options: writingOptions)
        } catch {
            return .failure(EthereumKitError.requestError(.invalidParameters(object)))
        }
        
        return .success(data)
    }
}
