public struct TimeOffset: Equatable {
    public enum Sign: Equatable {
        case plus
        case minus
    }

    public var sign: Sign
    public var hour: Int8
    public var minute: Int8

    public init?<H, M>(sign: Sign, hour: H, minute: M) where H: SignedInteger, M: SignedInteger {
        if hour.isInvalidHour || minute.isInvalidMinute {
            return nil
        }

        self.sign = sign
        self.hour = Int8(hour)
        self.minute = Int8(minute)
    }

    public static var zero: TimeOffset {
        return TimeOffset(sign: .plus, hour: 0, minute: 0)!
    }
}

extension TimeOffset {
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    init?(asciiValues: [Int8]) {
        if asciiValues.count == 1, let first = asciiValues.first, first == z || first == Z {
            self.sign = .plus
            self.hour = 0
            self.minute = 0
            return
        }

        if asciiValues.count < 6 || asciiValues[3] != colon {
            return nil
        }

        switch asciiValues[0] {
        case plus:
            self.sign = .plus
        case minus:
            self.sign = .minus
        default:
            return nil
        }

        let asciiValues = asciiValues.map { $0 - NetTime.zero }
        let hour = asciiValues[1] * 10 + asciiValues[2]
        if hour.isInvalidHour {
            return nil
        }
        self.hour = hour

        let minute = asciiValues[4] * 10 + asciiValues[5]
        if minute.isInvalidMinute {
            return nil
        }
        self.minute = minute
    }
}

extension TimeOffset: CustomStringConvertible {
    public var description: String {
        if self.hour == 0 && self.minute == 0 {
            return "Z"
        }

        let signString: String
        switch self.sign {
        case .minus:
            signString = "-"
        case .plus:
            signString = "+"
        }

        let hourString = "\(self.hour > 9 ? "" : "0")\(self.hour)"
        let minuteString = "\(self.minute > 9 ? "" : "0")\(self.minute)"

        return "\(signString)\(hourString):\(minuteString)"
    }
}
