public struct Address {
    public let data: Data
    public let string: String
    
    public init(data: Data) {
        self.data = data
        self.string = "0x" + EIP55.encode(data)
    }
    
    public init(string: String) {
        self.data = Data(hex: string.hex)
        self.string = string
    }
}
