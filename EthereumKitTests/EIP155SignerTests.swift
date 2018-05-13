import XCTest
@testable import EthereumKit

class EIP155SignerTests: XCTestCase {
    func testEIP155SigningOnTestnet() {
        let signer = EIP155Signer(chainID: 3)
        
        let rawTransaction1 = RawTransaction(
            value: Wei("10000000000000000")!,
            to: Address(string: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 2
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction1).toHexString(),
            "84df8756f832aa25f79fdeac98ae9adf83b1da0119dd3555807f890f09c3e1a7"
        )
        
        let rawTransaction2 = RawTransaction(
            value: Wei("10000000000000000")!,
            to: Address(string: "0x88b44BC83add758A3642130619D61682282850Df"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 4
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction2).toHexString(),
            "18f93470671a0db633e4346dfa5ecdc2568e2befdbf815ac205d9eef06a91350"
        )
        
        let rawTransaction3 = RawTransaction(
            value: Wei("10000000000000000")!,
            to: Address(string: "0x72AAb5461F9bE958E1c375285CC2aA7De89D02A1"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 25
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction3).toHexString(),
            "0af0867d4acb71dd0bd590b86aef78d7ccfdcdcf16e881e9f426e432a1603eaf"
        )
    }
    
    func testEIP155SigningOnMainnet() {
        let signer = EIP155Signer(chainID: 1)
        
        let rawTransaction1 = RawTransaction(
            value: Wei("10000000000000000")!,
            to: Address(string: "0x91c79f31De5208fadCbF83f0a7B0A9b6d8aBA90F"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 2
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction1).toHexString(),
            "de6ed032e8f09adb557f6a0ebc16ed52d6a75e0644a77a236aa1cfffa7746e9a"
        )
        
        let rawTransaction2 = RawTransaction(
            value: Wei("10000000000000000")!,
            to: Address(string: "0x88b44BC83add758A3642130619D61682282850Df"),
            gasPrice: 99000000000,
            gasLimit: 200000,
            nonce: 4
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction2).toHexString(),
            "b148272b2a985365e08abb17a85ca5e171169978f3b55e6852a035f83b9f3aa5"
        )
        
        let rawTransaction3 = RawTransaction(
            value: Wei("20000000000000000")!,
            to: Address(string: "0x72AAb5461F9bE958E1c375285CC2aA7De89D02A1"),
            gasPrice: 99000000000,
            gasLimit: 21000,
            nonce: 25
        )
        
        XCTAssertEqual(
            try! signer.hash(rawTransaction: rawTransaction3).toHexString(),
            "280e29f030cfa256b4298a2b834a4add92b37f159b3cce1110e1ff9f7514f9fe"
        )
    }
    
    func testGeneratingRSVOnTestnet1() {
        let signiture = Data(hex: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa63627667cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d8300")
        let signer = EIP155Signer(chainID: 3)
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        XCTAssertEqual(r, BInt("18515461264373351373200002665853028612451056578545711640558177340181847433846")!)
        XCTAssertEqual(s, BInt("46948507304638947509940763649030358759909902576025900602547168820602576006531")!)
        XCTAssertEqual(v, BInt(41))
        XCTAssertEqual(r.asString(withBase: 16), "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa636276")
        XCTAssertEqual(s.asString(withBase: 16), "67cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d83")
        XCTAssertEqual(v.asString(withBase: 16), "29")
        let restoredSignature = signer.calculateSignature(r: r, s: s, v: v)
        XCTAssertEqual(signiture, restoredSignature)
    }
    
    func testGeneratingRSVOnTestnet2() {
        let signiture = Data(hex: "5e7e818d4ca60295c42f0fab371e8a0409cb5080ba958a67d8d31cdcf18ae50b21fe08e591cb6d5f75d4a443818fdc3ee324f0599253cfd1f5b5c7ac17d0c73a00")
        let signer = EIP155Signer(chainID: 3)
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        XCTAssertEqual(r.asString(withBase: 16), "5e7e818d4ca60295c42f0fab371e8a0409cb5080ba958a67d8d31cdcf18ae50b")
        XCTAssertEqual(s.asString(withBase: 16), "21fe08e591cb6d5f75d4a443818fdc3ee324f0599253cfd1f5b5c7ac17d0c73a")
        XCTAssertEqual(v.asString(withBase: 16), "29")
        let restoredSignature = signer.calculateSignature(r: r, s: s, v: v)
        XCTAssertEqual(signiture, restoredSignature)
    }
    
    func testGeneratingRSVOnMainnet() {
        let signiture = Data(hex: "28ef61340bd939bc2195fe537567866003e1a15d3c71ff63e1590620aa63627667cbe9d8997f761aecb703304b3800ccf555c9f3dc64214b297fb1966a3b6d8300")
        let signer = EIP155Signer(chainID: 1)
        let (r, s, v) = signer.calculateRSV(signiture: signiture)
        XCTAssertEqual(r, BInt("18515461264373351373200002665853028612451056578545711640558177340181847433846")!)
        XCTAssertEqual(s, BInt("46948507304638947509940763649030358759909902576025900602547168820602576006531")!)
        XCTAssertEqual(v, BInt(37))
        let restoredSignature = signer.calculateSignature(r: r, s: s, v: v)
        XCTAssertEqual(signiture, restoredSignature)
    }
}
