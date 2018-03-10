public struct Configuration {
    public let network: Network
    public let nodeEndpoint: URL
    public let etherscanAPIKey: String
    
    public init(network: Network, nodeEndpoint: URL, etherscanAPIKey: String) {
        self.network = network
        self.nodeEndpoint = nodeEndpoint
        self.etherscanAPIKey = etherscanAPIKey
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
