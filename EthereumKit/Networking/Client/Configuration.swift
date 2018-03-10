public struct Configuration {
    public let network: Network
    public let nodeEndpoint: URL
    
    public init(network: Network, nodeEndpoint: URL) {
        self.network = network
        self.nodeEndpoint = nodeEndpoint
    }
    
    public var etherscanURL: URL {
        switch network {
        case .main:
            return URL(string: "https://etherscan.io")!
            
        case .ropsten:
            return URL(string: "https://ropsten.etherscan.io")!
        }
    }
}
