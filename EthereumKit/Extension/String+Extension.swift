extension String {
    public func stripHexPrefix() -> String {
        var hex = self
        while hex.first == "0" || hex.first == "x" {
            hex = String(hex.dropFirst())
        }
        return hex
    }
    
    public func addHexPrefix() -> String {
        return "0x".appending(self)
    }
    
    public func toHexString() -> String {
        return data(using: .utf8)!.map { String(format: "%02x", $0) }.joined()
    }
}
