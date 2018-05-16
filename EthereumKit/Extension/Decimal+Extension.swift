extension Decimal {
    func toHexString() -> String {
        return representationOf(base: 16)
    }
    
    private func representationOf(base: Decimal) -> String {
        var buffer: [Int] = []
        var n = self
        
        while n > 0 {
            buffer.append((n.truncatingRemainder(dividingBy: base) as NSDecimalNumber).intValue)
            n = n.integerDivisionBy(base)
        }
        
        return buffer
            .reversed()
            .map { String($0, radix: (base as NSDecimalNumber).intValue ) }
            .joined()
    }
    
    private func rounded(mode: NSDecimalNumber.RoundingMode) -> Decimal {
        var this = self
        var result = Decimal()
        NSDecimalRound(&result, &this, 0, mode)
        return result
    }
    
    private func integerDivisionBy(_ operand: Decimal) -> Decimal {
        let result = (self / operand)
        return result.rounded(mode: result < 0 ? .up : .down)
    }
    
    private func truncatingRemainder(dividingBy operand: Decimal) -> Decimal {
        return self - integerDivisionBy(operand) * operand
    }
}
