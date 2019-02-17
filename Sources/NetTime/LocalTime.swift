extension SignedInteger {
    fileprivate var isInvalidDigit: Bool {
        return self < 0 || self > 9
    }

    fileprivate var isInvalidSecond: Bool {
        return self < 0 || self > 60
    }

    var isInvalidMinute: Bool {
        return self < 0 || self > 59
    }

    var isInvalidHour: Bool {
        return self < 0 || self > 23
    }
}

public struct LocalTime: Equatable {
    public var hour: Int8
    public var minute: Int8
    public var second: Int8
    public var secondFraction: [Int8]

    public init?<H, M, S>(hour: H, minute: M, second: S, secondFraction: [Int8] = []) where
        H: SignedInteger, M: SignedInteger, S: SignedInteger
    {
        if hour.isInvalidHour ||
            minute.isInvalidMinute ||
            second.isInvalidSecond ||
            secondFraction.contains(where: { $0.isInvalidDigit })
        {
            return nil
        }

        self.hour = Int8(hour)
        self.minute = Int8(minute)
        self.second = Int8(second)
        self.secondFraction = secondFraction
    }
}

extension LocalTime {
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    public init(staticRFC3339String string: StaticString) {
        self.init(rfc3339String: string.description)!
    }

    init?(asciiValues: [Int8]) {
        guard asciiValues.count >= 8, asciiValues[2] == colon && asciiValues[5] == colon else  {
            return nil
        }

        let asciiValues = asciiValues.map { $0 - zero }

        let hour = asciiValues[0] * 10 + asciiValues[1]
        if hour.isInvalidHour {
            return nil
        }
        self.hour = hour

        let minute = asciiValues[3] * 10 + asciiValues[4]
        if minute.isInvalidMinute {
            return nil
        }
        self.minute = minute

        let second = asciiValues[6] * 10 + asciiValues[7]
        if second.isInvalidSecond {
            return nil
        }
        self.second = second

        var fraction = [Int8]()
        if asciiValues.count > 8 && asciiValues[8] + zero == dot {
            for digit in asciiValues[9...] {
                if digit.isInvalidDigit {
                    break
                }
                fraction.append(digit)
            }
        }

        self.secondFraction = fraction
    }
}

extension LocalTime: CustomStringConvertible {
    public var description: String {
        let hourString = "\(self.hour > 9 ? "" : "0")\(self.hour)"
        let minuteString = "\(self.minute > 9 ? "" : "0")\(self.minute)"
        let secondString = "\(self.second > 9 ? "" : "0")\(self.second)"
        let fractionString = self.secondFraction.isEmpty
            ? ""
            : ".\(self.secondFraction.map(String.init).joined(separator: ""))"
        return "\(hourString):\(minuteString):\(secondString)\(fractionString)"
    }
}
