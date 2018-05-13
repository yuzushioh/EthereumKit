import XCTest
import CryptoSwift
@testable import EthereumKit

class TransactionSigningTests: XCTestCase {
    
    func testTransactionSigning() {
        let rawTransaction = RawTransaction(
            value: Wei("1000000000000000000")!,
            to: Address(string: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 5
        )
        
        let signer = EIP155Signer(chainID: 3)
        let signiture = try! Crypto.sign(
            try! signer.hash(rawTransaction: rawTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = try! RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
        
        XCTAssertEqual(
            data.toHexString().addHexPrefix(), "0xf86c0585170cdc1e008252089491c79f31de5208fadcbf83f0a7b0a9b6d8aba90f880de0b6b3a76400008029a076da637d6a2fa3197c0a1b7c9bc2a4326c9a1dbe94c4eb8449bf59919f89b762a00887bcdd883f2cc2c892e55665419fad6522d4e7e1f7c226282078de98f4069c"
        )
    }
    
    func testTransactionSigning2() {
        let rawTransaction = RawTransaction(
            value: Wei("100000000000000000")!,
            to: Address(string: "0x3B958949EfCc8362Dd05179cCE8eB5e16BefeBdA"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 5
        )
        
        let signer = EIP155Signer(chainID: 3)
        let signiture = try! Crypto.sign(
            try! signer.hash(rawTransaction: rawTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = try! RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
        
        XCTAssertEqual(
            data.toHexString().addHexPrefix(), "0xf86c0585170cdc1e00825208943b958949efcc8362dd05179cce8eb5e16befebda88016345785d8a00008029a022ab35848cce6ddf0ef76ea6ab25cebe449d822073492c6e2b90a2707bd061d0a0414e6f152f66a62158a59a9ffe095bd1beacf0d2510b9204aec8a8cacbcbdf31"
        )
    }
    
    func testTransactionSigning3() {
        let rawTransaction = RawTransaction(
            value: Wei("500000000000000000")!,
            to: Address(string: "0xfc9d3987f7fcd9181393084a94814385b28cEf81"),
            gasPrice: 99000000000,
            gasLimit: 200000,
            nonce: 5
        )
        
        let signer = EIP155Signer(chainID: 3)
        let signiture = try! Crypto.sign(
            try! signer.hash(rawTransaction: rawTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = try! RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
        
        XCTAssertEqual(
            data.toHexString().addHexPrefix(), "0xf86d0585170cdc1e0083030d4094fc9d3987f7fcd9181393084a94814385b28cef818806f05b59d3b200008029a096479bbc675f9ae3bdc23f6fa22adf5bc009c1661b6336bdeaa2959dce6d55dba0302981091abc6dc4736676b93c24fde68d11bad45741a2d8c5bfdfb633039863"
        )
    }
    
    func testTransactionSigning4() {
        let rawTransaction = RawTransaction(
            value: Wei("1000000000000000000")!,
            to: Address(string: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 0
        )
        
        let signer = EIP155Signer(chainID: 1)
        let signiture = try! Crypto.sign(
            try! signer.hash(rawTransaction: rawTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = try! RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
        
        XCTAssertEqual(
            data.toHexString().addHexPrefix(), "0xf86c8085170cdc1e008252089491c79f31de5208fadcbf83f0a7b0a9b6d8aba90f880de0b6b3a76400008025a0f62b35ed65db13b02ccab29eeea2d29990a690a8620f8bee56b765c5357c82b8a05c266f2d429c87f8c903f7089870aa169638518c5c3a56ade8ce66ffcb5c3991"
        )
    }
    
    func testTransactionSigning5() {
        let rawTransaction = RawTransaction(
            value: Wei("1000000000000000000")!,
            to: Address(string: "0x3B958949EfCc8362Dd05179cCE8eB5e16BefeBdA"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 0
        )
        
        let signer = EIP155Signer(chainID: 1)
        let signiture = try! Crypto.sign(
            try! signer.hash(rawTransaction: rawTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = try! RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
        
        XCTAssertEqual(
            data.toHexString().addHexPrefix(), "0xf86c8085170cdc1e00825208943b958949efcc8362dd05179cce8eb5e16befebda880de0b6b3a76400008025a0134a7e77c95c5839bd931788f1b7a3ff15567d9a79ef0b00cfe4baedf33c60d8a00123a678f76e288a0180ef3248c90608365bf95d20d1a16b9b3d23edbe420408"
        )
    }
    
    func testTransactionSigning6() {
        let rawTransaction = RawTransaction(
            value: Wei("5000000000000000000")!,
            to: Address(string: "0xfc9d3987f7fcd9181393084a94814385b28cEf81"),
            gasPrice: 99000000000,
            gasLimit: 200000,
            nonce: 0
        )
        
        let signer = EIP155Signer(chainID: 1)
        let signiture = try! Crypto.sign(
            try! signer.hash(rawTransaction: rawTransaction),
            privateKey: Data(hex: "db173e58671248b48d2494b63a99008be473268581ca1eb78ed0b92e03b13bbc")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = try! RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
        
        XCTAssertEqual(
            data.toHexString().addHexPrefix(), "0xf86d8085170cdc1e0083030d4094fc9d3987f7fcd9181393084a94814385b28cef81884563918244f400008025a07f47866c109ce1fbc0b4c9d4c5825bcd9be13903a082256d70c8cf6c05a59bfca045f6b0407996511b30f72fbb567e0b0dbaa367b9b920f73ade435f8e0e2776b6"
        )
    }
    
    func testTransactionSigning7() {
        let rawTransaction = RawTransaction(
            value: Wei("1000000000000000")!,
            to: Address(string: "0x88b44BC83add758A3642130619D61682282850Df"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 0
        )
        
        let signer = EIP155Signer(chainID: 3)
        let signiture = try! Crypto.sign(
            try! signer.hash(rawTransaction: rawTransaction),
            privateKey: Data(hex: "0ac03c260512582a94295185cfa899e0cb8067a89a61b7b5435ec524c088203c")
        )
        
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        
        let data = try! RLP.encode([
            rawTransaction.nonce,
            rawTransaction.gasPrice,
            rawTransaction.gasLimit,
            rawTransaction.to.data,
            rawTransaction.value,
            rawTransaction.data,
            v, r, s
        ])
        
        XCTAssertEqual(
            data.toHexString().addHexPrefix(), "0xf86b8085170cdc1e008252089488b44bc83add758a3642130619d61682282850df87038d7ea4c680008029a01edbb41d5936c75314cd75d795e2c79ef8882eb6daa041f22a894f84dec7a97fa020569fc39ffa956592f40020b2afb710ba8dabebee4de32fb7dce22a1209b90d"
        )
    }
    
    func testTransactionSigningWithWallet() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = try! Wallet(seed: seed, network: .ropsten)
        
        // PrivateKey: - 0ac03c260512582a94295185cfa899e0cb8067a89a61b7b5435ec524c088203c
        
        let rawTransaction = RawTransaction(
            wei: "1000000000000000",
            to: "0x88b44BC83add758A3642130619D61682282850Df",
            gasPrice: Converter.toWei(GWei: 99),
            gasLimit: 21000,
            nonce: 2
        )
        
        let tx = try! wallet.sign(rawTransaction: rawTransaction)
        XCTAssertEqual(
            tx,
            "0xf86b0285170cdc1e008252089488b44bc83add758a3642130619d61682282850df87038d7ea4c680008029a0dbc4a4748e889d9921c28593fd8ad17edaee69ec992cc7a798229d8d5bd30c61a0407c70218b1bcff3bd6d824c14703b03b6744b66354226416053c2c4a73b5bc2"
        )
    }
    
    func testTransactionSigningWithWallet1() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = try! Wallet(seed: seed, network: .ropsten)
        
        // PrivateKey: - 0ac03c260512582a94295185cfa899e0cb8067a89a61b7b5435ec524c088203c
        
        let rawTransaction = RawTransaction(
            wei: "1000000000000000",
            to: "0x88b44BC83add758A3642130619D61682282850Df",
            gasPrice: Converter.toWei(GWei: 1),
            gasLimit: 21000,
            nonce: 2
        )
        
        let tx = try! wallet.sign(rawTransaction: rawTransaction)
        XCTAssertEqual(
            tx,
            "0xf86a02843b9aca008252089488b44bc83add758a3642130619d61682282850df87038d7ea4c680008029a0db114beaab321c241df4c7da6de7e4f4267019dbd20699a881483d063314fe00a066dc7e3a5c96160213de1cac1b48a21ef11da46531b78a08742399417477cd8e"
        )
    }
    
    func testTransactionSigningWithWallet2() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = try! Wallet(seed: seed, network: .ropsten)
        
        // PrivateKey: - 0ac03c260512582a94295185cfa899e0cb8067a89a61b7b5435ec524c088203c
        
        let rawTransaction = RawTransaction(
            wei: "1000000000000000",
            to: "0x88b44BC83add758A3642130619D61682282850Df",
            gasPrice: Converter.toWei(GWei: 10),
            gasLimit: 21000,
            nonce: 2
        )
        
        let tx = try! wallet.sign(rawTransaction: rawTransaction)
        XCTAssertEqual(
            tx,
            "0xf86b028502540be4008252089488b44bc83add758a3642130619d61682282850df87038d7ea4c680008029a0e947eb994fcc3f2dd3538a08e0fd39f2aa03281b6c0b6a8ffbc77a06835782d8a065ee30e21936676e6d1431a5eabb44a0111cc528a92b2021dfe1323adf7f3d10"
        )
    }
    
    func testTransactionSigningWithWallet3() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = try! Wallet(seed: seed, network: .ropsten)
        
        let rawTransaction = RawTransaction(
            wei: "100000000000000000",
            to: "0x88b44BC83add758A3642130619D61682282850Df",
            gasPrice: Converter.toWei(GWei: 41),
            gasLimit: 21000,
            nonce: 2
        )
        
        let tx = try! wallet.sign(rawTransaction: rawTransaction)
        XCTAssertEqual(
            tx,
        "0xf86c0285098bca5a008252089488b44bc83add758a3642130619d61682282850df88016345785d8a00008029a028959f3003dbd17385dec3348cdc62b348240a707bfce5827635a396d4ad02a0a033d1786b113fbc0578e6aafd345311fdc72d4a8e60a66da90159d93369c7246b"
        )
    }
    
    func testTransactionSigningWithWallet4() {
        let mnemonic = Mnemonic.create(entropy: Data(hex: "000102030405060708090a0b0c0d0e0f"))
        let seed = Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = try! Wallet(seed: seed, network: .ropsten)
        
        let rawTransaction = RawTransaction(
            wei: "1000000000000000000",
            to: "0x2F9eE3EdE488e3b7702Be866e2DC80A2a962f8a6",
            gasPrice: Converter.toWei(GWei: 41),
            gasLimit: 21000,
            nonce: 2
        )
        
        let tx = try! wallet.sign(rawTransaction: rawTransaction)
        XCTAssertEqual(
            tx,
        "0xf86c0285098bca5a00825208942f9ee3ede488e3b7702be866e2dc80a2a962f8a6880de0b6b3a76400008029a09ce012054ee76b1ac9cd442335a00de747d8536eda6639a1f65e4fac5002fb9ba05c26e5e9263d86d36835f29b38ed62cd0575875eea62ea7022c231db6e7d5b44"
        )
    }
}
