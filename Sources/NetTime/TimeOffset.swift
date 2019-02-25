/// Time offset in relation to a timezone. This is designed to represent and
/// preserve the offset portion of a timestamp formatted according to
/// [RFC 3339][].
///
/// [RFC 3339]: https://tools.ietf.org/html/rfc3339
public struct TimeOffset: Equatable {
    /// Represents sign for the offset.
    public enum Sign: Equatable {
        case plus
        case minus
    }

    /// The sign.
    public var sign: Sign
    /// The hour potion.
    public var hour: Int8
    /// The minute potion.
    public var minute: Int8

    /// Creates an offset from its components. If any value doesn't make sense
    /// for its purpose, fail the creation.
    ///
    /// - Parameters:
    ///   - sign: The sign of the offset.
    ///   - hour: The hour potion of the offset. Between 0 and 23.
    ///   - minute: The minute potion of the offset. Between 0 and 59.
    public init?<H, M>(sign: Sign, hour: H, minute: M)
        where H: SignedInteger, M: SignedInteger
    {
        if hour.isInvalidHour || minute.isInvalidMinute {
            return nil
        }

        self.sign = sign
        self.hour = Int8(hour)
        self.minute = Int8(minute)
    }

    /// The value for the offset `+00:00`
    public static var zero: TimeOffset {
        return TimeOffset(sign: .plus, hour: 0, minute: 0)!
    }

    /// The number of seconds contained in this offset, including the sign.
    public var asSeconds: Int {
        let factor: Int
        switch self.sign {
        case .plus:
            factor = 1
        case .minus:
            factor = -1
        }

        return factor * Int(self.minute) * 60 + Int(self.hour) * 3600
    }
}

extension TimeOffset {
    /// Create an `Offset` from an offset segement of an [RFC 3339][] timestamp.
    /// Initialization will fail if the input does not comply with the format
    /// specified in [RFC 3339][].
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: The offset potion of a timestamp conforming
    ///                            to the format specified in RFC 3339.
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    /// Create a `TimeOffset` from an offset segement of an [RFC 3339][]
    /// timestamp. An input that does not comply with [RFC 3339] will cause a
    /// trap in runtime.
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: The date potion of a timestamp conforming to
    ///                            the format specified in RFC 3339.
    public init(staticRFC3339String string: StaticString) {
        self.init(rfc3339String: string.description)!
    }

    /// Create an `Offset` from an offset segement of an [RFC 3339][] timestamp.
    /// Initialization will fail if the input does not comply with the format
    /// specified in [RFC 3339][].
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: The offset potion of a timestamp conforming
    ///                            to the format specified in RFC 3339. The
    ///                            content should be the same as argument of
    ///                            `init(rfc3339String:)`. Terminating `0` value
    ///                            from C strings should be excluded.
    public init?<S>(asciiValues: S) where S: RandomAccessCollection, S.Element == CChar, S.Index == Int {
        if asciiValues.count == 1,
            let first = asciiValues.first,
            first == z || first == Z
        {
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
    /// Serialized description of `TimeOffset` in RFC 3339 format.
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
