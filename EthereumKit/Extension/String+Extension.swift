extension String {
    public func stripHexPrefix() -> String {
        var hex = self
        let prefix = "0x"
        if hex.hasPrefix(prefix) {
            hex = String(hex.dropFirst(prefix.count))
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
