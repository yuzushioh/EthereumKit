extension String {
    public var hex: String {
        var hex = self
        while hex.first == "0" || hex.first == "x" {
            hex = String(hex.dropFirst())
        }
        return hex
    }
    
    public var appending0xPrefix: String {
        return "0x".appending(self)
    }
}
