//
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||||||||||                       SMP Core.swift                       ||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————
//	Created by Marcel Kröker on 30.09.16.
//	Copyright (c) 2016 Blubyte. All rights reserved.
//
//
//
//	——————————————————————————————————————————— v1.0 ———————————————————————————————————————————
//	- Initial Release.
//
//	——————————————————————————————————————————— v1.1 ———————————————————————————————————————————
//	- Improved String conversion, now about 45x faster, uses base 10^9 instead
//	of base 10.
//	- bytes renamed to limbs.
//	- Uses typealias for limbs and digits.
//
//	——————————————————————————————————————————— v1.2 ———————————————————————————————————————————
//	- Improved String conversion, now about 10x faster, switched from base 10^9
//	to 10^18 (biggest possible decimal base).
//	- Implemented karatsuba multiplication algorithm, about 5x faster than the
//	previous algorithm.
//	- Addition is 1.3x faster.
//	- Addtiton and subtraction omit trailing zeros, algorithms need less
//	operations now.
//	- Implemented exponentiation by squaring.
//	- New storage (BStorage) for often used results.
//	- Uses uint_fast64_t instead of UInt64 for Limbs and Digits.
//
//	——————————————————————————————————————————— v1.3 ———————————————————————————————————————————
//	- Huge Perfomance increase by skipping padding zeros and new multiplication
//	algotithms.
//	- Printing is now about 10x faster, now on par with GMP.
//	- Some operations now use multiple cores.
//
//	——————————————————————————————————————————— v1.4 ———————————————————————————————————————————
//	- Reduced copying by using more pointers.
//	- Multiplication is about 50% faster.
//	- String to BInt conversion is 2x faster.
//	- BInt to String also performs 50% better.
//
//	——————————————————————————————————————————— v1.5 ———————————————————————————————————————————
//	- Updated for full Swift 3 compatibility.
//	- Various optimizations:
//		- Multiplication is about 2x faster.
//		- BInt to String conversion is more than 3x faster.
//		- String to BInt conversion is more than 2x faster.
//
//	——————————————————————————————————————————— v1.6 ———————————————————————————————————————————
//	- Code refactored into modules.
//	- Renamed the project to SMP (Swift Multiple Precision).
//	- Added arbitrary base conversion.
//
//	——————————————————————————————————————————— v2.0 ———————————————————————————————————————————
//	- Updated for full Swift 4 compatibility.
//	- Big refactor, countless optimizations for even better performance.
//	- BInt conforms to SignedNumeric and BinaryInteger, this makes it very easy to write
//	  generic code.
//	- BDouble also conforms to SignedNumeric and has new functionalities.
//
//
//
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||||||||||                         Evolution                          ||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————
//
//
//
//	Planned features of BInt v3.0:
//	- Implement some basic cryptography functions.
//	- General code cleanup, better documentation.
//	- More extensive tests.
//	- Please contact me if you have any suggestions for new features!
//
//
//
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||||||||||              Basic Project syntax conventions              ||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————
//
//	Indentation: Tabs
//
//	Align: Spaces
//
//	Style: allman
//	func foo(...)
//	{
//		...
//	}
//
//	Single line if-statement:
//	if condition { code }
//
//	Maximum line length: 96 characters
//
//	————————————————————————————————————————————————————————————————————————————————————————————
// MARK: - Imports
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||        Imports        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————

import Foundation

// MARK: - Typealiases
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||        Typealiases        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————
//	Limbs are basically single Digits in base 2^64. Each slot in an Limbs array stores one
//	Digit of the number. The least significant digit is stored at index 0, the most significant
//	digit is stored at the last index.

public typealias Limbs  = [UInt64]
public typealias Limb = UInt64

//	A digit is a number in base 10^18. This is the biggest possible base that
//	fits into an unsigned 64 bit number while maintaining the propery that the square root of
//	the base is a whole number and a power of ten . Digits are required for printing BInt
//	numbers. Limbs are converted into Digits first, and then printed.

public typealias Digits = [UInt64]
public typealias Digit = UInt64

// MARK: - Imports
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||        Operators        |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————

precedencegroup ExponentiationPrecedence {
	associativity: left
	higherThan: MultiplicationPrecedence
	lowerThan: BitwiseShiftPrecedence
}

// Exponentiation operator
infix operator ** : ExponentiationPrecedence

// MARK: - BInt
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||        BInt        ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————
///	BInt is an arbitrary precision integer value type. It stores a number in base 2^64 notation
///	as an array. Each element of the array is called a limb, which is of type UInt64, the whole
///	array is called limbs and has the type [UInt64]. A boolean sign variable determines if the
///	number is positive or negative. If sign == true, then the number is smaller than 0,
///	otherwise it is greater or equal to 0. It stores the 64 bit digits in little endian, that
///	is, the least significant digit is stored in the array index 0:
///
///		limbs == [] := undefined, should throw an error
///		limbs == [0], sign == false := 0, defined as positive
///		limbs == [0], sign == true := undefined, should throw an error
///		limbs == [n] := n if sign == false, otherwise -n, given 0 <= n < 2^64
///
///		limbs == [l0, l1, l2, ..., ln] :=
///		(l0 * 2^(0*64)) +
///		(11 * 2^(1*64)) +
///		(12 * 2^(2*64)) +
///		... +
///		(ln * 2^(n*64))
public struct BInt: SignedNumeric, // Implies Numeric, Equatable, ExpressibleByIntegerLiteral
	BinaryInteger, // Implies Hashable, CustomStringConvertible, Strideable, Comparable
	ExpressibleByFloatLiteral {
	//
	//
	// MARK: - Internal data
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Internal data        |||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	internal var sign = false
	internal var limbs = Limbs()

	// Required by protocol Numeric
	public typealias Magnitude = UInt64

	// Required by protocol Numeric
	public var magnitude: UInt64 {
		return self.limbs[0]
	}

	public typealias Words = [UInt]

	/// A collection containing the words of this value’s binary representation, in order from
	///	the least significant to most significant.
	public var words: BInt.Words {
		return self.limbs.map { UInt($0) }
	}

	/// Returns the size of the BInt in bits.
	public var size: Int {
		return 1 + (self.limbs.count * MemoryLayout<Limb>.size * 8)
	}

	//
	//
	// MARK: - Initializers
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Initializers        ||||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	///	Root initializer for all other initializers. Because no sign is provided, the new
	///	instance is positive by definition.
	internal init(limbs: Limbs) {
		precondition(limbs != [], "BInt can't be initialized with limbs == []")
		self.limbs = limbs
	}

	/// Create an instance initialized with a sign and a limbs array.
	internal init(sign: Bool, limbs: Limbs) {
		self.init(limbs: limbs)
		self.sign = sign
	}

	/// Create an instance initialized with the value 0.
	init() {
		self.init(limbs: [0])
	}

	/// Create an instance initialized to an integer value.
	public init(_ z: Int) {
		//	Since abs(Int.min) > Int.max, it is necessary to handle
		//	z == Int.min as a special case.
		if z == Int.min {
			self.init(sign: true, limbs: [Limb(Int.max) + 1])
			return
		} else {
			self.init(sign: z < 0, limbs: [Limb(abs(z))])
		}
	}

	/// Create an instance initialized to an unsigned integer value.
	public init(_ n: UInt) {
		self.init(limbs: [Limb(n)])
	}

	/// Create an instance initialized to a string value.
	public init?(_ str: String) {
		var str = str
		var sign = false
		var base: Limbs = [1]
		var limbs: Limbs = [0]

		limbs.reserveCapacity(Int(Double(str.count) / log10(pow(2.0, 64.0))))

		if str.hasPrefix("-") {
			str.remove(at: str.startIndex)
			sign = str != "0"
		}

		for chunk in String(str.reversed()).split(19).map({ String($0.reversed()) }) {
			if let num = Limb(String(chunk)) {
				limbs.addProductOf(multiplier: base, multiplicand: num)
				base = base.multiplyingBy([10_000_000_000_000_000_000])
			} else {
				return nil
			}
		}

		self.init(sign: sign, limbs: limbs)
	}
	
	/// Create an instance initialized to a string with the value of mathematical numerical system of the specified radix (base).
	/// So for example, to get the value of hexadecimal string radix value must be set to 16.
	public init?(_ nStr: String, radix: Int) {
		if radix == 10 {
			// regular string init is faster
			// see metrics
			self.init(nStr)
			return
		}
		
		var useString = nStr
		if radix == 16 {
			if useString.hasPrefix("0x") {
				useString = String(nStr.dropFirst(2))
			}
		}
		
		if radix == 8 {
			if useString.hasPrefix("0o") {
				useString = String(nStr.dropFirst(2))
			}
		}
		
		if radix == 2 {
			if useString.hasPrefix("0b") {
				useString = String(nStr.dropFirst(2))
			}
		}
		
		let bint16 = BInt(radix)
		
		var total = BInt(0)
		var exp = BInt(1)
		
		for c in useString.reversed() {
			let int = Int(String(c), radix: radix)
			if int != nil {
				let value = BInt(int!)
				total = total + (value * exp)
				exp = exp * bint16
			} else {
				return nil
			}
			
		}
		
		self.init(String(describing: total))
	}

	//	Requierd by protocol ExpressibleByFloatLiteral.
	public init(floatLiteral value: Double) {
		self.init(sign: value < 0.0, limbs: [Limb(value)])
	}

	//	Required by protocol ExpressibleByIntegerLiteral.
	public init(integerLiteral value: Int) {
		self.init(value)
	}

	// Required by protocol Numeric
	public init?<T>(exactly source: T) where T: BinaryInteger {
		self.init(Int(source))
	}

	///	Creates an integer from the given floating-point value, rounding toward zero.
	public init<T>(_ source: T) where T: BinaryFloatingPoint {
		self.init(Int(source))
	}

	///	Creates a new instance from the given integer.
	public init<T>(_ source: T) where T: BinaryInteger {
		self.init(Int(source))
	}

	///	Creates a new instance with the representable value that’s closest to the given integer.
	public init<T>(clamping source: T) where T: BinaryInteger {
		self.init(Int(source))
	}

	///	Creates an integer from the given floating-point value, if it can be represented
	///	exactly.
	public init?<T>(exactly source: T) where T: BinaryFloatingPoint {
		self.init(source)
	}

	///	Creates a new instance from the bit pattern of the given instance by sign-extending or
	///	truncating to fit this type.
	public init<T>(truncatingIfNeeded source: T) where T: BinaryInteger {
		self.init(source)
	}

	//
	//
	// MARK: - CustomStringConvertible conformance
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        CustomStringConvertible conformance        |||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	public var description: String {
		return (self.sign ? "-" : "").appending(self.limbs.decimalRepresentation)
	}

	public init?(number: String, withBase base: Int) {
		self.init(number.convertingBase(from: base, toBase: 10))
	}

	public func asString(withBase base: Int) -> String {
		let str = self.limbs.decimalRepresentation
		let newStr = str.convertingBase(from: 10, toBase: base)

		if self.sign { return "-".appending(newStr) }
		return newStr
	}

	//
	//
	// MARK: - Struct functions
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Struct functions        ||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	///	Returns BInt value as an integer, if possible.
	func toInt() -> Int? {
		//	Conversion only works when self has only one limb thats smaller or
		//	equal to abs(Int.min).

		if self.limbs.count != 1 { return nil }

		let number = self.limbs[0]

		//	Self is within the range of Int
		if number <= Limb(Int.max) {
			return self.sign ? -Int(number) : Int(number)
		}

		//	Special case: self == Int.min
		if number == (Limb(Int.max) + 1) && self.sign {
			return Int.min
		}

		return nil
	}

	var rawValue: (sign: Bool, limbs: [UInt64]) {
		return (self.sign, self.limbs)
	}

	public var hashValue: Int {
		return "\(self.sign)\(self.limbs)".hashValue
	}

	///	A Boolean value indicating whether this type is a signed integer type.
	public static var isSigned: Bool {
		return true
	}

	///	Returns -1 if this value is negative and 1 if it’s positive; otherwise, 0.
	public func signum() -> BInt {
		if self.isZero() { return BInt(0) } else if self.isPositive() { return BInt(1) } else { return BInt(-1) }
	}

	func isPositive() -> Bool { return !self.sign }
	func isNegative() -> Bool { return  self.sign }
	func isZero() -> Bool { return self.limbs[0] == 0 && self.limbs.count == 1 }
	func isNotZero() -> Bool { return self.limbs[0] != 0 || self.limbs.count > 1 }
	func isOdd() -> Bool { return self.limbs[0] & 1 == 1 }
	func isEven() -> Bool { return self.limbs[0] & 1 == 0 }

	///	The number of bits in the current binary representation of this value.
	public var bitWidth: Int {
		return self.limbs.bitWidth
	}

	///	The number of trailing zeros in this value’s binary representation.
	public var trailingZeroBitCount: Int {
		var i = 0
		while true {
			if self.limbs.getBit(at: i) { return i }
			i += 1
		}
	}
    
    /// Serialization
    public func serialize() -> Data {
        let byteCount = (bitWidth + 7) / 8
        guard byteCount > 0 else { return Data()}
        
        var data = Data(count: byteCount)
        data.withUnsafeMutableBytes { (p: UnsafeMutablePointer<UInt8>) -> Void in
            var i = byteCount - 1
            for var word in words {
                for _ in 0 ..< UInt.bitWidth / 8 {
                    p[i] = UInt8(word & 0xFF)
                    word >>= 8
                    if i == 0 {
                        assert(word == 0)
                        break
                    }
                    i -= 1
                }
            }
        }
        return data
    }

	//
	//
	// MARK: - BInt Shifts
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Shifts        |||||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	public static func <<<T: BinaryInteger>(lhs: BInt, rhs: T) -> BInt {
		if rhs < 0 { return lhs >> rhs }

		let limbs = lhs.limbs.shiftingUp(Int(rhs))
		let sign = lhs.isNegative() && !limbs.equalTo(0)

		return BInt(sign: sign, limbs: limbs)
	}

	public static func <<=<T: BinaryInteger>(lhs: inout BInt, rhs: T) {
		lhs.limbs.shiftUp(Int(rhs))
	}

	public static func >><T: BinaryInteger>(lhs: BInt, rhs: T) -> BInt {
		if rhs < 0 { return lhs << rhs }
		return BInt(sign: lhs.sign, limbs: lhs.limbs.shiftingDown(Int(rhs)))
	}

	public static func >>=<T: BinaryInteger>(lhs: inout BInt, rhs: T) {
		lhs.limbs.shiftDown(Int(rhs))
	}

	//
	//
	// MARK: - BInt Bitwise AND
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt BInt Bitwise AND        |||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	///	Returns the result of performing a bitwise AND operation on the two given values.
	public static func &(lhs: BInt, rhs: BInt) -> BInt {
		var res: Limbs = [0]

		for i in 0..<(64 * Swift.max(lhs.limbs.count, rhs.limbs.count)) {
			let newBit = lhs.limbs.getBit(at: i) && lhs.limbs.getBit(at: i)
			res.setBit(at: i, to: newBit)
		}

		return BInt(sign: lhs.sign && rhs.sign, limbs: res)
	}

	//	static func &(lhs: Int, rhs: BInt) -> BInt
	//	static func &(lhs: BInt, rhs: Int) -> BInt

	///	Stores the result of performing a bitwise AND operation on the two given values in the
	///	left-hand-side variable.
	public static func &=(lhs: inout BInt, rhs: BInt) {
		let res = lhs & rhs
		lhs = res
	}

	//	static func &=(inout lhs: Int, rhs: BInt)
	//	static func &=(inout lhs: BInt, rhs: Int)

	//
	//
	// MARK: - BInt Bitwise OR
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Bitwise OR        |||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	public static func |(lhs: BInt, rhs: BInt) -> BInt {
		var res: Limbs = [0]

		for i in 0..<(64 * Swift.max(lhs.limbs.count, rhs.limbs.count)) {
			let newBit = lhs.limbs.getBit(at: i) || lhs.limbs.getBit(at: i)
			res.setBit(at: i, to: newBit)
		}

		return BInt(sign: lhs.sign || rhs.sign, limbs: res)
	}

	//	static func |(lhs: Int, rhs: BInt) -> BInt
	//	static func |(lhs: BInt, rhs: Int) -> BInt
	//
	public static func |=(lhs: inout BInt, rhs: BInt) {
		let res = lhs | rhs
		lhs = res
	}
	//	static func |=(inout lhs: Int, rhs: BInt)
	//	static func |=(inout lhs: BInt, rhs: Int)

	//
	//
	// MARK: - BInt Bitwise OR
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Bitwise XOR        ||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	public static func ^(lhs: BInt, rhs: BInt) -> BInt {
		var res: Limbs = [0]

		for i in 0..<(64 * Swift.max(lhs.limbs.count, rhs.limbs.count)) {
			let newBit = lhs.limbs.getBit(at: i) != lhs.limbs.getBit(at: i)
			res.setBit(at: i, to: newBit)
		}

		return BInt(sign: lhs.sign != rhs.sign, limbs: res)
	}

	public static func ^=(lhs: inout BInt, rhs: BInt) {
		let res = lhs | rhs
		lhs = res
	}

	//
	//
	// MARK: - BInt Bitwise NOT
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Bitwise NOT        ||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	public prefix static func ~(x: BInt) -> BInt {
		var res = x.limbs
		for i in 0..<(res.bitWidth) {
			res.setBit(at: i, to: !res.getBit(at: i))
		}

		while res.last! == 0 && res.count > 1 { res.removeLast() }

		return BInt(sign: !x.sign, limbs: res)
	}

	//
	//
	// MARK: - BInt Addition
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Addition        |||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	public prefix static func +(x: BInt) -> BInt {
		return x
	}

	// Required by protocol Numeric
	public static func +=(lhs: inout BInt, rhs: BInt) {
		if lhs.sign == rhs.sign {
			lhs.limbs.addLimbs(rhs.limbs)
			return
		}

		let rhsIsMin = rhs.limbs.lessThan(lhs.limbs)
		lhs.limbs.difference(rhs.limbs)
		lhs.sign = (rhs.sign && !rhsIsMin) || (lhs.sign && rhsIsMin) // DNF minimization

		if lhs.isZero() { lhs.sign = false }
	}

	// Required by protocol Numeric
	public static func +(lhs: BInt, rhs: BInt) -> BInt {
		var lhs = lhs
		lhs += rhs
		return lhs
	}

	static func +(lhs: Int, rhs: BInt) -> BInt { return BInt(lhs) + rhs }
	static func +(lhs: BInt, rhs: Int) -> BInt { return lhs + BInt(rhs) }

	static func +=(lhs: inout  Int, rhs: BInt) { lhs += (BInt(lhs) + rhs).toInt()! }
	static func +=(lhs: inout BInt, rhs: Int) { lhs += BInt(rhs)                 }

	//
	//
	// MARK: - BInt Negation
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Negation        |||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	// Required by protocol SignedNumeric
	public mutating func negate() {
		if self.isNotZero() { self.sign = !self.sign }
	}

	// Required by protocol SignedNumeric
	public static prefix func -(n: BInt) -> BInt {
		var n = n
		n.negate()
		return n
	}

	//
	//
	// MARK: - BInt Subtraction
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Subtraction        ||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	// Required by protocol Numeric
	public static func -(lhs: BInt, rhs: BInt) -> BInt {
		return lhs + -rhs
	}

	static func -(lhs: Int, rhs: BInt) -> BInt { return BInt(lhs) - rhs }
	static func -(lhs: BInt, rhs: Int) -> BInt { return lhs - BInt(rhs) }

	// Required by protocol Numeric
	public static func -=(lhs: inout BInt, rhs: BInt) { lhs += -rhs                        }
	static func -=(lhs: inout  Int, rhs: BInt) { lhs = (BInt(lhs) - rhs).toInt()! }
	static func -=(lhs: inout BInt, rhs: Int) { lhs -= BInt(rhs)                  }

	//
	//
	// MARK: - BInt Multiplication
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Multiplication        |||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	// Required by protocol Numeric
	public static func *(lhs: BInt, rhs: BInt) -> BInt {
		let sign = !(lhs.sign == rhs.sign || lhs.isZero() || rhs.isZero())
		return BInt(sign: sign, limbs: lhs.limbs.multiplyingBy(rhs.limbs))
	}

	static func *(lhs: Int, rhs: BInt) -> BInt { return BInt(lhs) * rhs }
	static func *(lhs: BInt, rhs: Int) -> BInt { return lhs * BInt(rhs) }

	// Required by protocol SignedNumeric
	public static func *=(lhs: inout BInt, rhs: BInt) { lhs = lhs * rhs                  }
	static func *=(lhs: inout  Int, rhs: BInt) { lhs = (BInt(lhs) * rhs).toInt()! }
	static func *=(lhs: inout BInt, rhs: Int) { lhs = lhs * BInt(rhs)            }

	//
	//
	// MARK: - BInt Exponentiation
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Exponentiation        |||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	static func **(lhs: BInt, rhs: Int) -> BInt {
		precondition(rhs >= 0, "BInts can't be exponentiated with exponents < 0")
		return BInt(sign: lhs.sign && (rhs % 2 != 0), limbs: lhs.limbs.exponentiating(rhs))
	}

	func factorial() -> BInt {
		precondition(!self.sign, "Can't calculate the factorial of an negative number")

		return BInt(limbs: Limbs.recursiveMul(0, Limb(self.toInt()!)))
	}

	//
	//
	// MARK: - BInt Division
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Division        |||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	///	Returns the quotient and remainder of this value divided by the given value.
	public func quotientAndRemainder(dividingBy rhs: BInt) -> (quotient: BInt, remainder: BInt) {
		let limbRes = self.limbs.divMod(rhs.limbs)
		return (BInt(limbs: limbRes.quotient), BInt(limbs: limbRes.remainder))
	}

	public static func /(lhs: BInt, rhs: BInt) -> BInt {
		let limbs = lhs.limbs.divMod(rhs.limbs).quotient
		let sign = (lhs.sign != rhs.sign) && !limbs.equalTo(0)

		return BInt(sign: sign, limbs: limbs)
	}

	static func /(lhs: Int, rhs: BInt) -> BInt { return BInt(lhs) / rhs }
	static func /(lhs: BInt, rhs: Int) -> BInt { return lhs / BInt(rhs) }

	public static func /=(lhs: inout BInt, rhs: BInt) { lhs = lhs / rhs       }
	static func /=(lhs: inout BInt, rhs: Int) { lhs = lhs / BInt(rhs) }

	//
	//
	// MARK: - BInt Modulus
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Modulus        ||||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	public static func %(lhs: BInt, rhs: BInt) -> BInt {
		let limbs = lhs.limbs.divMod(rhs.limbs).remainder
		let sign = lhs.sign && !limbs.equalTo(0)

		return BInt(sign: sign, limbs: limbs)
	}

	static func %(lhs: Int, rhs: BInt) -> BInt { return BInt(lhs) % rhs  }
	static func %(lhs: BInt, rhs: Int) -> BInt { return lhs % BInt(rhs) }

	public static func %=(lhs: inout BInt, rhs: BInt) { lhs = lhs % rhs       }
	static func %=(lhs: inout BInt, rhs: Int) { lhs = lhs % BInt(rhs) }

	//
	//
	// MARK: - BInt Comparing
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        BInt Comparing        ||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	// Required by protocol Equatable
	public static func ==(lhs: BInt, rhs: BInt) -> Bool {
		if lhs.sign != rhs.sign { return false }
		return lhs.limbs == rhs.limbs
	}

	static func ==<T: BinaryInteger>(lhs: BInt, rhs: T) -> Bool {
		if lhs.limbs.count != 1 { return false }
		return lhs.limbs[0] == rhs
	}

	static func ==<T: BinaryInteger>(lhs: T, rhs: BInt) -> Bool { return rhs == lhs }

	static func !=(lhs: BInt, rhs: BInt) -> Bool {
		if lhs.sign != rhs.sign { return true }
		return lhs.limbs != rhs.limbs
	}

	static func !=<T: BinaryInteger>(lhs: BInt, rhs: T) -> Bool {
		if lhs.limbs.count != 1 { return true }
		return lhs.limbs[0] != rhs
	}

	static func !=<T: BinaryInteger>(lhs: T, rhs: BInt) -> Bool { return rhs != lhs }

	// Required by protocol Comparable
	public static func <(lhs: BInt, rhs: BInt) -> Bool {
		if lhs.sign != rhs.sign { return lhs.sign }

		if lhs.sign { return rhs.limbs.lessThan(lhs.limbs) }
		return lhs.limbs.lessThan(rhs.limbs)
	}

	static func <<T: BinaryInteger>(lhs: BInt, rhs: T) -> Bool {
		if lhs.sign != (rhs < 0) { return lhs.sign }

		if lhs.sign {
			if lhs.limbs.count != 1 { return true }
			return rhs < lhs.limbs[0]
		} else {
			if lhs.limbs.count != 1 { return false }
			return lhs.limbs[0] < rhs
		}

	}

	static func <(lhs: Int, rhs: BInt) -> Bool { return BInt(lhs) < rhs }
	static func <(lhs: BInt, rhs: Int) -> Bool { return lhs < BInt(rhs) }

	// Required by protocol Comparable
	public static func >(lhs: BInt, rhs: BInt) -> Bool { return rhs < lhs       }
	static func >(lhs: Int, rhs: BInt) -> Bool { return BInt(lhs) > rhs }
	static func >(lhs: BInt, rhs: Int) -> Bool { return lhs > BInt(rhs) }

	// Required by protocol Comparable
	public static func <=(lhs: BInt, rhs: BInt) -> Bool { return !(rhs < lhs)       }
	static func <=(lhs: Int, rhs: BInt) -> Bool { return !(rhs < BInt(lhs)) }
	static func <=(lhs: BInt, rhs: Int) -> Bool { return !(BInt(rhs) < lhs) }

	// Required by protocol Comparable
	public static func >=(lhs: BInt, rhs: BInt) -> Bool { return !(lhs < rhs)       }
	static func >=(lhs: Int, rhs: BInt) -> Bool { return !(BInt(lhs) < rhs) }
	static func >=(lhs: BInt, rhs: Int) -> Bool { return !(lhs < BInt(rhs)) }
}
//
//
// MARK: - String operations
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||        String operations        |||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————
//
//
//
fileprivate extension String {
	// Splits the string into equally sized parts (exept for the last one).
	func split(_ count: Int) -> [String] {
		return stride(from: 0, to: self.count, by: count).map { i -> String in
			let start = index(startIndex, offsetBy: i)
			let end = index(start, offsetBy: count, limitedBy: endIndex) ?? endIndex
			return String(self[start..<end])
		}
	}

	///	Assuming that this String represents a number in some base fromBase, return a String
	///	that contains the number converted to base toBase.
	func convertingBase(from: Int, toBase: Int) -> String {
		let chars: [Character] = [
			"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b",
			"c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
			"o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
			"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
			"M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
			"Y", "Z"
		]

		var res = ""
		var number = self

		if number.hasPrefix("-") {
			res = "-"
			number.removeFirst()
		}

		var sum = BInt(0)
		var multiplier = BInt(1)

		for char in number.reversed() {
			if let digit = chars.index(of: char) {
				precondition(digit < from)

				sum += digit * multiplier
				multiplier *= from
			} else {
				fatalError()
			}
		}

		repeat {
			res.insert(chars[(sum % toBase).toInt()!], at: res.startIndex)
			sum /= BInt(toBase)
		}
			while sum != 0

		return res
	}
}
private let DigitBase: Digit = 1_000_000_000_000_000_000
private let DigitHalfBase: Digit = 1_000_000_000
private let DigitZeros = 18
fileprivate extension Array where Element == Limb {
	var decimalRepresentation: String {
		// First, convert limbs to digits
		var digits: Digits = [0]
		var power: Digits = [1]

		for limb in self {
			let digit = (limb >= DigitBase)
				? [limb % DigitBase, limb / DigitBase]
				: [limb]

			digits.addProductOfDigits(digit, power)

			var nextPower: Digits = [0]
			nextPower.addProductOfDigits(power, [446_744_073_709_551_616, 18])
			power = nextPower
		}

		// Then, convert digits to string
		var res = String(digits.last!)

		if digits.count == 1 { return res }

		for i in (0..<(digits.count - 1)).reversed() {
			let str = String(digits[i])

			let leadingZeros = String(repeating: "0", count: DigitZeros - str.count)

			res.append(leadingZeros.appending(str))
		}

		return res
	}
}
fileprivate extension Digit {
	mutating func addReportingOverflowDigit(_ addend: Digit) -> Bool {
		self = self &+ addend
		if self >= DigitBase { self -= DigitBase; return true }
		return false
	}

	func multipliedFullWidthDigit(by multiplicand: Digit) -> (Digit, Digit) {
		let (lLo, lHi) = (self % DigitHalfBase, self / DigitHalfBase)
		let (rLo, rHi) = (multiplicand % DigitHalfBase, multiplicand / DigitHalfBase)

		let K = (lHi * rLo) + (rHi * lLo)

		var resLo = (lLo * rLo) + ((K % DigitHalfBase) * DigitHalfBase)
		var resHi = (lHi * rHi) + (K / DigitHalfBase)

		if resLo >= DigitBase {
			resLo -= DigitBase
			resHi += 1
		}

		return (resLo, resHi)
	}
}
fileprivate extension Array where Element == Digit {
	mutating func addOneDigit(
		_ addend: Limb,
		padding paddingZeros: Int
		) {
		let sc = self.count

		if paddingZeros > sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
		if paddingZeros >= sc { self.append(addend); return }

		// Now, i < sc
		var i = paddingZeros

		let ovfl = self[i].addReportingOverflowDigit(addend)

		while ovfl {
			i += 1
			if i == sc { self.append(1); return }
			self[i] += 1
			if self[i] != DigitBase { return }
			self[i] = 0
		}
	}

	mutating func addTwoDigit(
		_ addendLow: Limb,
		_ addendHigh: Limb,
		padding paddingZeros: Int) {
		let sc = self.count

		if paddingZeros > sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
		if paddingZeros >= sc { self += [addendLow, addendHigh]; return }

		// Now, i < sc
		var i = paddingZeros
		var newDigit: Digit

		let ovfl1 = self[i].addReportingOverflowDigit(addendLow)
		i += 1

		if i == sc {
			newDigit = (addendHigh &+ (ovfl1 ? 1 : 0)) % DigitBase
			self.append(newDigit)
			if newDigit == 0 { self.append(1) }
			return
		}

		// Still, i < sc
		var ovfl2 = self[i].addReportingOverflowDigit(addendHigh)
		if ovfl1 {
			self[i] += 1
			if self[i] == DigitBase { self[i] = 0; ovfl2 = true }
		}

		while ovfl2 {
			i += 1
			if i == sc { self.append(1); return }
			self[i] += 1
			if self[i] != DigitBase { return }
			self[i] = 0
		}
	}

	mutating func addProductOfDigits(_ multiplier: Digits, _ multiplicand: Digits) {
		let (mpc, mcc) = (multiplier.count, multiplicand.count)
		self.reserveCapacity(mpc &+ mcc)

		var l, r, resLo, resHi: Digit

		for i in 0..<mpc {
			l = multiplier[i]
			if l == 0 { continue }

			for j in 0..<mcc {
				r = multiplicand[j]
				if r == 0 { continue }

				(resLo, resHi) = l.multipliedFullWidthDigit(by: r)

				if resHi == 0 {
					self.addOneDigit(resLo, padding: i + j)
				} else {
					self.addTwoDigit(resLo, resHi, padding: i + j)
				}
			}
		}
	}
}
//
//
// MARK: - Limbs extension
//	————————————————————————————————————————————————————————————————————————————————————————————
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||        Limbs extension        |||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//	————————————————————————————————————————————————————————————————————————————————————————————
//
//
//
// Extension to Limbs type
fileprivate extension Array where Element == Limb {
	//
	//
	// MARK: - Limbs bitlevel
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Limbs bitlevel        ||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	/// Returns the number of bits that contribute to the represented number, ignoring all
	/// leading zeros.
	var bitWidth: Int {
		var lastBits = 0
		var last = self.last!

		while last != 0 {
			last >>= 1
			lastBits += 1
		}

		return ((self.count - 1) * 64) + lastBits
	}

	///	Get bit i of limbs.
	func getBit(at i: Int) -> Bool {
		let limbIndex = Int(Limb(i) >> 6)

		if limbIndex >= self.count { return false }

		let bitIndex = Limb(i) & 0b111_111

		return (self[limbIndex] & (1 << bitIndex)) != 0
	}

	/// Set bit i of limbs to b. b must be 0 for false, and everything else for true.
	mutating func setBit(
		at i: Int,
		to bit: Bool
		) {
		let limbIndex = Int(Limb(i) >> 6)

		if limbIndex >= self.count && !bit { return }

		let bitIndex = Limb(i) & 0b111_111

		while limbIndex >= self.count { self.append(0) }

		if bit {
			self[limbIndex] |= (1 << bitIndex)
		} else {
			self[limbIndex] &= ~(1 << bitIndex)
		}
	}

	//
	//
	// MARK: - Limbs Shifting
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Limbs Shifting        ||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	mutating func shiftUp(_ shift: Int) {
		// No shifting is required in this case
		if shift == 0 || self.equalTo(0) { return }

		let limbShifts = shift >> 6
		let bitShifts = Limb(shift) & 0x3f

		if bitShifts != 0 {
			var previousCarry = Limb(0)
			var carry = Limb(0)
			var ele = Limb(0) // use variable to minimize array accesses

			for i in 0..<self.count {
				ele = self[i]

				carry = ele >> (64 - bitShifts)

				ele <<= bitShifts
				ele |= previousCarry // carry from last step
				previousCarry = carry

				self[i] = ele
			}

			if previousCarry != 0 { self.append(previousCarry) }
		}

		if limbShifts != 0 {
			self.insert(contentsOf: Limbs(repeating: 0, count: limbShifts), at: 0)
		}
	}

	func shiftingUp(_ shift: Int) -> Limbs {
		var res = self
		res.shiftUp(shift)
		return res
	}

	mutating func shiftDown(_ shift: Int) {
		if shift == 0 || self.equalTo(0) { return }

		let limbShifts = shift >> 6
		let bitShifts = Limb(shift) & 0x3f

		if limbShifts >= self.count {
			self = [0]
			return
		}

		self.removeSubrange(0..<limbShifts)

		if bitShifts != 0 {
			var previousCarry = Limb(0)
			var carry = Limb(0)
			var ele = Limb(0) // use variable to minimize array accesses

			var i = self.count - 1 // use while for high performance
			while i >= 0 {
				ele = self[i]

				carry = ele << (64 - bitShifts)

				ele >>= bitShifts
				ele |= previousCarry
				previousCarry = carry

				self[i] = ele

				i -= 1
			}
		}

		if self.last! == 0 && self.count != 1 { self.removeLast() }
	}

	func shiftingDown(_ shift: Int) -> Limbs {
		var res = self
		res.shiftDown(shift)
		return res
	}

	//
	//
	// MARK: - Limbs Addition
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Limbs Addition        ||||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	mutating func addLimbs(_ addend: Limbs) {
		let (sc, ac) = (self.count, addend.count)

		var (newLimb, ovfl) = (Limb(0), false)

		let minCount = Swift.min(sc, ac)

		var i = 0
		while i < minCount {
			if ovfl {
				(newLimb, ovfl) = self[i].addingReportingOverflow(addend[i])
				newLimb = newLimb &+ 1

				ovfl = ovfl || newLimb == 0
			} else {
				(newLimb, ovfl) = self[i].addingReportingOverflow(addend[i])
			}

			self[i] = newLimb
			i += 1
		}

		while ovfl {
			if i < sc {
				if i < ac {
					(newLimb, ovfl) = self[i].addingReportingOverflow(addend[i])
					newLimb = newLimb &+ 1
					ovfl = ovfl || newLimb == 0
				} else {
					(newLimb, ovfl) = self[i].addingReportingOverflow(1)
				}

				self[i] = newLimb
			} else {
				if i < ac {
					(newLimb, ovfl) = addend[i].addingReportingOverflow(1)
					self.append(newLimb)
				} else {
					self.append(1)
					return
				}
			}

			i += 1
		}

		if self.count < ac {
			self.append(contentsOf: addend.suffix(from: i))
		}
	}

	/// Adding Limbs and returning result
	func adding(_ addend: Limbs) -> Limbs {
		var res = self
		res.addLimbs(addend)
		return res
	}

	// CURRENTLY NOT USED:
	///	Add the addend to Limbs, while using a padding at the lower end.
	///	Every zero is a Limb, that means one padding zero equals 64 padding bits
	mutating func addLimbs(
		_ addend: Limbs,
		padding paddingZeros: Int
		) {
		let sc = self.count

		if paddingZeros > sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
		if paddingZeros >= sc { self += addend; return }

		// Now, i < sc
		let ac = addend.count &+ paddingZeros

		var (newLimb, ovfl) = (Limb(0), false)

		let minCount = Swift.min(sc, ac)

		var i = paddingZeros
		while i < minCount {
			if ovfl {
				(newLimb, ovfl) = self[i].addingReportingOverflow(addend[i &- paddingZeros])
				newLimb = newLimb &+ 1
				self[i] = newLimb
				ovfl = ovfl || newLimb == 0
			} else {
				(self[i], ovfl) = self[i].addingReportingOverflow(addend[i &- paddingZeros])
			}

			i += 1
		}

		while ovfl {
			if i < sc {
				let adding = i < ac ? addend[i &- paddingZeros] &+ 1 : 1
				(self[i], ovfl) = self[i].addingReportingOverflow(adding)
				ovfl = ovfl || adding == 0
			} else {
				if i < ac {
					(newLimb, ovfl) = addend[i &- paddingZeros].addingReportingOverflow(1)
					self.append(newLimb)
				} else {
					self.append(1)
					return
				}
			}

			i += 1
		}

		if self.count < ac {
			self.append(contentsOf: addend.suffix(from: i &- paddingZeros))
		}
	}

	mutating func addOneLimb(
		_ addend: Limb,
		padding paddingZeros: Int
		) {
		let sc = self.count

		if paddingZeros > sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
		if paddingZeros >= sc { self.append(addend); return }

		// Now, i < lhc
		var i = paddingZeros

		var ovfl: Bool
		(self[i], ovfl) = self[i].addingReportingOverflow(addend)

		while ovfl {
			i += 1
			if i == sc { self.append(1); return }
			(self[i], ovfl) = self[i].addingReportingOverflow(1)
		}
	}

	/// Basically self.addOneLimb([addendLow, addendHigh], padding: paddingZeros), but faster
	mutating func addTwoLimb(
		_ addendLow: Limb,
		_ addendHigh: Limb,
		padding paddingZeros: Int) {
		let sc = self.count

		if paddingZeros > sc { self += Digits(repeating: 0, count: paddingZeros &- sc) }
		if paddingZeros >= sc { self += [addendLow, addendHigh]; return }

		// Now, i < sc
		var i = paddingZeros
		var newLimb: Limb

		var ovfl1: Bool
		(self[i], ovfl1) = self[i].addingReportingOverflow(addendLow)
		i += 1

		if i == sc {
			newLimb = addendHigh &+ (ovfl1 ? 1 : 0)
			self.append(newLimb)
			if newLimb == 0 { self.append(1) }
			return
		}

		// Still, i < sc
		var ovfl2: Bool
		(self[i], ovfl2) = self[i].addingReportingOverflow(addendHigh)

		if ovfl1 {
			self[i] = self[i] &+ 1
			if self[i] == 0 { ovfl2 = true }
		}

		while ovfl2 {
			i += 1
			if i == sc { self.append(1); return }
			(self[i], ovfl2) = self[i].addingReportingOverflow(1)
		}
	}

	//
	//
	// MARK: - Limbs Subtraction
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Limbs Subtraction        |||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	/// Calculates difference between Limbs in left limb
	mutating func difference(_ subtrahend: Limbs) {
		var subtrahend = subtrahend
		// swap to get difference
		if self.lessThan(subtrahend) { swap(&self, &subtrahend) }

		let rhc = subtrahend.count
		var ovfl = false

		var i = 0

		// skip first zeros
		while i < rhc && subtrahend[i] == 0 { i += 1 }

		while i < rhc {
			if ovfl {
				(self[i], ovfl) = self[i].subtractingReportingOverflow(subtrahend[i])
				self[i] = self[i] &- 1
				ovfl = ovfl || self[i] == Limb.max
			} else {
				(self[i], ovfl) = self[i].subtractingReportingOverflow(subtrahend[i])
			}

			i += 1
		}

		while ovfl {
			if i >= self.count {
				self.append(Limb.max)
				break
			}

			(self[i], ovfl) = self[i].subtractingReportingOverflow(1)

			i += 1
		}

		if self.count > 1 && self.last! == 0 // cut excess zeros if required
		{
			var j = self.count - 2
			while j >= 1 && self[j] == 0 { j -= 1 }

			self.removeSubrange((j + 1)..<self.count)
		}
	}

	func differencing(_ subtrahend: Limbs) -> Limbs {
		var res = self
		res.difference(subtrahend)
		return res
	}

	//
	//
	// MARK: - Limbs Multiplication
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Limbs Multiplication        |||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	mutating func addProductOf(
		multiplier: Limbs,
		multiplicand: Limbs
	) {
		let (mpc, mcc) = (multiplier.count, multiplicand.count)

		self.reserveCapacity(mpc + mcc)

		// Minimize array subscript calls
		var l, r, mulHi, mulLo: Limb

		for i in 0..<mpc {
			l = multiplier[i]
			if l == 0 { continue }

			for j in 0..<mcc {
				r = multiplicand[j]
				if r == 0 { continue }

				(mulHi, mulLo) = l.multipliedFullWidth(by: r)

				if mulHi != 0 { self.addTwoLimb(mulLo, mulHi, padding: i + j) } else { self.addOneLimb(mulLo, padding: i + j) }
			}
		}
	}

	// Perform res += (lhs * r)
	mutating func addProductOf(
		multiplier: Limbs,
		multiplicand: Limb
		) {
		if multiplicand < 2 {
			if multiplicand == 1 { self.addLimbs(multiplier) }
			// If r == 0 then do nothing with res
			return
		}

		// Minimize array subscript calls
		var l, mulHi, mulLo: Limb

		for i in 0..<multiplier.count {
			l = multiplier[i]
			if l == 0 { continue }

			(mulHi, mulLo) = l.multipliedFullWidth(by: multiplicand)

			if mulHi != 0 { self.addTwoLimb(mulLo, mulHi, padding: i) } else {          self.addOneLimb(mulLo, padding: i) }
		}
	}

	func multiplyingBy(_ multiplicand: Limbs) -> Limbs {
		var res: Limbs = [0]
		res.addProductOf(multiplier: self, multiplicand: multiplicand)
		return res
	}

	func squared() -> Limbs {
		var res: Limbs = [0]
		res.reserveCapacity(2 * self.count)

		// Minimize array subscript calls
		var l, r, mulHi, mulLo: Limb

		for i in 0..<self.count {
			l = self[i]
			if l == 0 { continue }

			for j in 0...i {
				r = self[j]
				if r == 0 { continue }

				(mulHi, mulLo) = l.multipliedFullWidth(by: r)

				if mulHi != 0 {
					if i != j { res.addTwoLimb(mulLo, mulHi, padding: i + j) }
					res.addTwoLimb(mulLo, mulHi, padding: i + j)
				} else {
					if i != j { res.addOneLimb(mulLo, padding: i + j) }
					res.addOneLimb(mulLo, padding: i + j)
				}
			}
		}

		return res
	}

	//
	//
	// MARK: - Limbs Exponentiation
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Limbs Exponentiation        ||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	// Exponentiation by squaring
	func exponentiating(_ exponent: Int) -> Limbs {
		if exponent == 0 { return [1] }
		if exponent == 1 { return self }

		var base = self
		var exponent = exponent
		var y: Limbs = [1]

		while exponent > 1 {
			if exponent & 1 != 0 { y = y.multiplyingBy(base) }
			base = base.squared()
			exponent >>= 1
		}

		return base.multiplyingBy(y)
	}

	/// Calculate (n + 1) * (n + 2) * ... * (k - 1) * k
	static func recursiveMul(_ n: Limb, _ k: Limb) -> Limbs {
		if n >= k - 1 { return [k] }

		let m = (n + k) >> 1

		return recursiveMul(n, m).multiplyingBy(recursiveMul(m, k))
	}

	func factorial(_ base: Int) -> BInt {
		return BInt(limbs: Limbs.recursiveMul(0, Limb(base)))
	}

	//
	//
	// MARK: - Limbs Division and Modulo
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Limbs Division and Modulo        |||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	/// An O(n) division algorithm that returns quotient and remainder.
	func divMod(_ divisor: Limbs) -> (quotient: Limbs, remainder: Limbs) {
		precondition(!divisor.equalTo(0), "Division or Modulo by zero not allowed")

		if self.equalTo(0) { return ([0], [0]) }

		var (quotient, remainder): (Limbs, Limbs) = ([0], [0])
		var (previousCarry, carry, ele): (Limb, Limb, Limb) = (0, 0, 0)

		// bits of lhs minus one bit
		var i = (64 * (self.count - 1)) + Int(log2(Double(self.last!)))

		while i >= 0 {
			// shift remainder by 1 to the left
			for r in 0..<remainder.count {
				ele = remainder[r]
				carry = ele >> 63
				ele <<= 1
				ele |= previousCarry // carry from last step
				previousCarry = carry
				remainder[r] = ele
			}
			if previousCarry != 0 { remainder.append(previousCarry) }

			remainder.setBit(at: 0, to: self.getBit(at: i))

			if !remainder.lessThan(divisor) {
				remainder.difference(divisor)
				quotient.setBit(at: i, to: true)
			}

			i -= 1
		}

		return (quotient, remainder)
	}

	/// Division with limbs, result is floored to nearest whole number.
	func dividing(_ divisor: Limbs) -> Limbs {
		return self.divMod(divisor).quotient
	}

	/// Modulo with limbs, result is floored to nearest whole number.
	func modulus(_ divisor: Limbs) -> Limbs {
		return self.divMod(divisor).remainder
	}

	//
	//
	// MARK: - Limbs Comparing
	//	————————————————————————————————————————————————————————————————————————————————————————
	//	||||||||        Limbs Comparing        |||||||||||||||||||||||||||||||||||||||||||||||||
	//	————————————————————————————————————————————————————————————————————————————————————————
	//
	//
	//

	//	Note:
	//	a < b iff b > a
	//	a <= b iff b >= a
	//	but:
	//	a < b iff !(a >= b)
	//	a <= b iff !(a > b)

	func lessThan(_ compare: Limbs) -> Bool {
		let lhsc = self.count
		let rhsc = compare.count

		if lhsc != rhsc {
			return lhsc < rhsc
		}

		var i = lhsc - 1
		while i >= 0 {
			if self[i] != compare[i] { return self[i] < compare[i] }
			i -= 1
		}

		return false // lhs == rhs
	}

	func equalTo(_ compare: Limb) -> Bool {
		return self[0] == compare && self.count == 1
	}
}
