/// `URLEncodedSerialization` parses `Data` and `String` as urlencoded,
/// and returns dictionary that represents the data or the string.
public final class URLEncodedSerialization {
    
    /// Returns urlencoded `String` from the dictionary.
    public static func string(from dictionary: [String: Any]) -> String {
        let pairs = dictionary.map { key, value -> String in
            if value is NSNull {
                return "\(escape(key))"
            }
            
            let valueAsString = (value as? String) ?? "\(value)"
            return "\(escape(key))=\(escape(valueAsString))"
        }
        
        return pairs.joined(separator: "&")
    }
    
    private static func escape(_ string: String) -> String {
        // Reserved characters defined by RFC 3986
        // Reference: https://www.ietf.org/rfc/rfc3986.txt
        let generalDelimiters = ":#[]@"
        let subDelimiters = "!$&'()*+,;="
        let reservedCharacters = generalDelimiters + subDelimiters
        
        var allowedCharacterSet = CharacterSet()
        allowedCharacterSet.formUnion(.urlQueryAllowed)
        allowedCharacterSet.remove(charactersIn: reservedCharacters)
        
        // Crashes due to internal bug in iOS 7 ~ iOS 8.2.
        // References:
        //   - https://github.com/Alamofire/Alamofire/issues/206
        //   - https://github.com/AFNetworking/AFNetworking/issues/3028
        // return string.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacterSet) ?? string
        
        let batchSize = 50
        var index = string.startIndex
        
        var escaped = ""
        
        while index != string.endIndex {
            let startIndex = index
            let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
            let range = startIndex..<endIndex
            
            let substring = String(string[range])
            
            escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? substring
            
            index = endIndex
        }
        
        return escaped
    }
}
