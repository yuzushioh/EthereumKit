public enum Endpoint {
    case mainnet, ropsten
    
    public init(network: Network) {
        switch network {
        case .main: self = .mainnet
        case .test: self = .ropsten
        }
    }
    
    public var infuraURL: URL {
        switch self {
        case .mainnet: return URL(string: "https://mainnet.infura.io/z1sEfnzz0LLMsdYMX4PV")!
        case .ropsten: return URL(string: "https://ropsten.infura.io/z1sEfnzz0LLMsdYMX4PV")!
        }
    }
    
    public var etherscanURL: URL {
        switch self {
        case .mainnet: return URL(string: "https://etherscan.io")!
        case .ropsten: return URL(string: "https://ropsten.etherscan.io")!
        }
    }
}
