import XCTest
@testable import EthereumKit

final class BIP32Tests: XCTestCase {
    
    private var hdPrivateKey: HDPrivateKey = {
        let seed = Data(hex: "000102030405060708090a0b0c0d0e0f")
        return HDPrivateKey(seed: seed, network: .mainnet)
    }()
    
    /// Test vectors in https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki
    
    func testMasterChain() {
        // Test Chain m
        XCTAssertEqual(
            hdPrivateKey.extended(),
            "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi"
        )
        
        XCTAssertEqual(
            hdPrivateKey.hdPublicKey().extended(),
            "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8"
        )
    }
    
    func testFirstDerivedChain() {
        
        // Test Chain m/0H
        let privateKey = try! hdPrivateKey
            .derived(at: 0, hardens: true)
        
        XCTAssertEqual(
            privateKey.extended(),
            "xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7"
        )
        
        XCTAssertEqual(
            privateKey.hdPublicKey().extended(),
            "xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw"
        )
    }
    
    func testSecondDerivedChain() {
        
        // Test Chain m/0H/1
        let privateKey = try! hdPrivateKey
            .derived(at: 0, hardens: true)
            .derived(at: 1)
        
        XCTAssertEqual(
            privateKey.extended(),
            "xprv9wTYmMFdV23N2TdNG573QoEsfRrWKQgWeibmLntzniatZvR9BmLnvSxqu53Kw1UmYPxLgboyZQaXwTCg8MSY3H2EU4pWcQDnRnrVA1xe8fs"
        )
        
        XCTAssertEqual(
            privateKey.hdPublicKey().extended(),
            "xpub6ASuArnXKPbfEwhqN6e3mwBcDTgzisQN1wXN9BJcM47sSikHjJf3UFHKkNAWbWMiGj7Wf5uMash7SyYq527Hqck2AxYysAA7xmALppuCkwQ"
        )
    }
    
    func testThirdDerivedChain() {
        
        // Test Chain m/0H/1/2H
        let privateKey = try! hdPrivateKey
            .derived(at: 0, hardens: true)
            .derived(at: 1)
            .derived(at: 2, hardens: true)
        
        XCTAssertEqual(
            privateKey.extended(),
            "xprv9z4pot5VBttmtdRTWfWQmoH1taj2axGVzFqSb8C9xaxKymcFzXBDptWmT7FwuEzG3ryjH4ktypQSAewRiNMjANTtpgP4mLTj34bhnZX7UiM"
        )
        
        XCTAssertEqual(
            privateKey.hdPublicKey().extended(),
            "xpub6D4BDPcP2GT577Vvch3R8wDkScZWzQzMMUm3PWbmWvVJrZwQY4VUNgqFJPMM3No2dFDFGTsxxpG5uJh7n7epu4trkrX7x7DogT5Uv6fcLW5"
        )
    }
    
    func testForthDerivedChain() {
        
        // Test Chain m/0H/1/2H/2
        let privateKey = try! hdPrivateKey
            .derived(at: 0, hardens: true)
            .derived(at: 1)
            .derived(at: 2, hardens: true)
            .derived(at: 2)
        
        XCTAssertEqual(
            privateKey.extended(),
            "xprvA2JDeKCSNNZky6uBCviVfJSKyQ1mDYahRjijr5idH2WwLsEd4Hsb2Tyh8RfQMuPh7f7RtyzTtdrbdqqsunu5Mm3wDvUAKRHSC34sJ7in334"
        )
        
        XCTAssertEqual(
            privateKey.hdPublicKey().extended(),
            "xpub6FHa3pjLCk84BayeJxFW2SP4XRrFd1JYnxeLeU8EqN3vDfZmbqBqaGJAyiLjTAwm6ZLRQUMv1ZACTj37sR62cfN7fe5JnJ7dh8zL4fiyLHV"
        )
    }
    
    func testRandomIndexChain() {
        
        // Test chain m/0H/1/2H/2/1000000000
        
        let privateKey = try! hdPrivateKey
            .derived(at: 0, hardens: true)
            .derived(at: 1)
            .derived(at: 2, hardens: true)
            .derived(at: 2)
            .derived(at: 1000000000)
        
        XCTAssertEqual(
            privateKey.extended(),
            "xprvA41z7zogVVwxVSgdKUHDy1SKmdb533PjDz7J6N6mV6uS3ze1ai8FHa8kmHScGpWmj4WggLyQjgPie1rFSruoUihUZREPSL39UNdE3BBDu76"
        )
        
        XCTAssertEqual(
            privateKey.hdPublicKey().extended(),
            "xpub6H1LXWLaKsWFhvm6RVpEL9P4KfRZSW7abD2ttkWP3SSQvnyA8FSVqNTEcYFgJS2UaFcxupHiYkro49S8yGasTvXEYBVPamhGW6cFJodrTHy"
        )
    }
}
