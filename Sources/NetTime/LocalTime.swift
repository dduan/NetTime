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

/// A time in Gregorian calendar, not specific to any timezone.
public struct LocalTime: Equatable {
    /// The hour in 24-hour format.
    public var hour: Int8
    /// The minute.
    public var minute: Int8
    /// The second.
    public var second: Int8
    /// A fraction of a second, represented by an array whose elements are
    /// decimal digit of the fraction. `[9, 1]` means 0.91 second.
    public var secondFraction: [Int8]
    /// Creates a time from its components. If any of the componet value does
    /// not exist in a clock, fail the creation.
    ///
    /// - Parameters:
    ///   - hour: The hour in 24 hour format, beteen 0 and 233
    ///   - minute: The minute, between 0 and 59
    ///   - second: The second, between 0 and 60 (60 is allowed in case of leap
    ///             seconds, according to RFC 3339).
    ///   - secondFraction: The list of decimal digit for the sub-second.
    public init?<H, M, S>(hour: H, minute: M, second: S,
                          secondFraction: [Int8] = [])
        where H: SignedInteger, M: SignedInteger, S: SignedInteger
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
    /// Create a `LocalTime` from an time segement of an [RFC 3339][] timestamp.
    /// Initialization will fail if the input does not comply with the format
    /// specified in [RFC 3339][].
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: The time potion of a timestamp conforming to
    ///                            the format specified in RFC 3339.
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    /// Create a `LocalTime` from an time segement of an [RFC 3339][] timestamp.
    /// An input that does not comply with [RFC 3339] will cause a trap in
    /// runtime.
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: The date potion of a timestamp conforming to
    ///                            the format specified in RFC 3339.
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
    /// Serialized description of `LocalTime` in RFC 3339 format.
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
