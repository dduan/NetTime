/// A moment in time. Represented in relation to UTC. The era is assumed to be
/// the current era. Dates and time are in accordance to the Gregorian calendar.
///
/// This type is designed to preserves information as defined in [RFC 3339][] as
/// much as poosible.
///
/// [RFC 3339]: https://tools.ietf.org/html/rfc3339
public struct DateTime: Equatable {
    /// Year, month, day potion of the moment.
    public var date: LocalDate
    /// Hour, minute, second, sub-second potion of the moment.
    public var time: LocalTime
    /// Time offset from the UTC time.
    public var utcOffset: TimeOffset

    /// Create a `DateTime`.
    ///
    /// - Parameters:
    ///   - date: The date potion of the moment.
    ///   - time: The time potion of the moment.
    ///   - utcOffset: The offset to UTC for the moment.
    public init(date: LocalDate, time: LocalTime, utcOffset: TimeOffset = .zero)
    {
        self.date = date
        self.time = time
        self.utcOffset = utcOffset
    }
}

extension DateTime: DateTimeRepresentable {}

extension DateTime {
    /// Create a `DateTime` from an [RFC 3339][] timestamp. Initialization will
    /// fail if the input does not comply with the format specified in
    /// [RFC 3339][].
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: A timestamp conforming to the format
    ///                            specified in RFC 3339.
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    /// Create a `DateTime` from an [RFC 3339][] timestamp. An input that does
    /// not comply with [RFC 3339][] will cause a trap in runtime.
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter staticRFC3339String: A timestamp conforming to the format
    ///                                  specified in RFC 3339.
    public init(staticRFC3339String string: StaticString) {
        self.init(rfc3339String: string.description)!
    }

    /// Create a `DateTime` from an [RFC 3339][] timestamp. Initialization will
    /// fail if the input does not comply with the format specified in
    /// [RFC 3339][].
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
        guard asciiValues.count == 20
            || asciiValues.count == 25
            || asciiValues.count > 26,
            let date = LocalDate(asciiValues: Array(asciiValues[0 ..< 10])),
            let time = LocalTime(asciiValues: Array(asciiValues[11...])),
            case let timezoneStart = time.secondFraction.count
                + 19
                + (time.secondFraction.isEmpty ? 0 : 1),
            let offset = TimeOffset(
                asciiValues: Array(asciiValues[timezoneStart...]))
        else
        {
            return nil
        }
        self.date = date
        self.time = time
        self.utcOffset = offset
    }
}

extension DateTime: CustomStringConvertible {
    /// Serialized description of `DateTime` in RFC 3339 format.
    public var description: String {
        return "\(self.date)T\(self.time)\(self.utcOffset)"
    }
}

#if os(Linux)
import Glibc
#else
import Darwin
#endif

extension DateTime {
    /// Number of seconds, including as much sub-second precesion as possible,
    /// from 1970-01-01 00:00:00+00:00.
    ///
    /// Note: if you need to convert to a `Foundation.Date`, please consider
    ///       using `DateTime.timeIntervalSince2001`.
    public var timeIntervalSince1970: Double {
        return Double(self.wholeSecondsSince1970) + self.fractionalSeconds
    }

    /// Number of seconds, including as much sub-second precesion as possible,
    /// from 2001-01-01 00:00:00+00:00.
    ///
    /// Note: 2001-01-01 is `Foundation.Date`'s epoch. Pass this value to
    ///       `Foundatio.Date.init(timeIntervalSinceReferenceDate:)` if you need
    ///       a conversion.
    public var timeIntervalSince2001: Double {
        return Double(self.wholeSecondsSince1970 - 978307200) + self.fractionalSeconds
    }

    private var wholeSecondsSince1970: Int {
        var time = tm()
        time.tm_year = Int32(self.year - 1900)
        time.tm_mon = Int32(self.month) - 1
        time.tm_mday = Int32(self.day)
        time.tm_hour = Int32(self.hour)
        time.tm_min = Int32(self.minute)
        time.tm_sec = Int32(self.second)


        let localSeconds = mktime(&time)
        let wholeSeconds = localSeconds - self.utcOffset.asSeconds + time.tm_gmtoff
        return wholeSeconds
    }

    private var fractionalSeconds: Double {
        return self.time.secondFraction.reversed().reduce(0) { ($0 + Double($1)) / 10 }
    }
}
