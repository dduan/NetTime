/// A moment in time in a unspecifed time zone. The era is assumed to be
/// the current era. Dates and time are in accordance to the Gregorian calendar.
///
/// This type is designed to preserves information as defined in [RFC 3339][] as
/// much as poosible.
///
/// [RFC 3339]: https://tools.ietf.org/html/rfc3339
public struct LocalDateTime: Equatable, Codable {
    /// Year, month, day potion of the moment.
    public var date: LocalDate
    /// Hour, minute, second, sub-second potion of the moment.
    public var time: LocalTime

    /// Create a `DateTime`.
    ///
    /// - Parameters:
    ///   - date: The date potion of the moment.
    ///   - time: The time potion of the moment.
    public init(date: LocalDate, time: LocalTime) {
        self.date = date
        self.time = time
    }
}

extension LocalDateTime: DateTimeRepresentable {}

extension LocalDateTime {
    /// Create a `LocalDateTime` from an [RFC 3339][] timestamp. Initialization
    /// will /// fail if the input does not comply with the format specified in
    /// [RFC 3339][]. Time offset will be ignored.
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: A timestamp conforming to the format
    ///                            specified in RFC 3339.
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    /// Create a `DateTime` from an [RFC 3339][] timestamp. An input that does
    /// not comply with [RFC 3339][] will cause a trap in runtime. Time offset
    /// will be ignored.
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter staticRFC3339String: A timestamp conforming to the format
    ///                                  specified in RFC 3339.
    public init(staticRFC3339String string: StaticString) {
        self.init(rfc3339String: string.description)!
    }

    /// Create a `LocalDateTime` from an [RFC 3339][] timestamp. Initialization
    /// will /// fail if the input does not comply with the format specified in
    /// [RFC 3339][]. Time offset will be ignored.
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: A timestamp conforming to the format
    ///                            specified in RFC 3339. the format specified
    ///                            in RFC 3339. The content should be the same
    ///                            as argument of `init(rfc3339String:)`.
    ///                            Terminating `0` value from C strings should
    ///                            be excluded.
    public init?<S>(asciiValues: S) where S: RandomAccessCollection, S.Element == CChar, S.Index == Int {
        guard asciiValues.count >= 19,
            case let separator = asciiValues[10],
            (separator == T || separator == t || separator == space),
            let date = LocalDate(asciiValues: Array(asciiValues[0 ..< 10])),
            let time = LocalTime(asciiValues: Array(asciiValues[11...]))
            else
        {
            return nil
        }

        self.date = date
        self.time = time
    }
}

extension LocalDateTime: CustomStringConvertible {
    /// Serialized description of `LocalDateTime` in RFC 3339 format.
    public var description: String {
        return "\(self.date)T\(self.time)"
    }
}
