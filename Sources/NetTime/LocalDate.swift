extension SignedInteger {
    fileprivate var isInvalidYear: Bool {
        return self < 1 || self > 9999
    }

    fileprivate var isInvalidMonth: Bool {
        return self < 1 || self > 12
    }

    fileprivate func isInvalidDay<Y, M>(inYear year: Y, month: M) -> Bool
        where Y: SignedInteger, M: SignedInteger
    {
        let maxDayCount: Self
        let isLeapYear = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
        switch month {
        case 2:
            maxDayCount = isLeapYear ? 29 : 28
        case 4, 6, 9, 11:
            maxDayCount = 30
        default:
            maxDayCount = 31
        }

        return self < 1 || self > maxDayCount
    }
}

/// A date in Gregorian calendar, not specific to any timezone.
public struct LocalDate: Equatable, Codable {
    /// The year.
    public var year: Int16
    /// The month.
    public var month: Int8
    /// The day.
    public var day: Int8

    /// Creates a date from its components. If any of the componet value does
    /// not exist in the calendar, fail the creation.
    ///
    /// - Parameters:
    ///   - year: A year between 0000 and 9999.
    ///   - month: A month between 1 and 12.
    ///   - day: Day of the month.
    public init?<Y, M, D>(year: Y, month: M, day: D)
        where Y: SignedInteger, M: SignedInteger, D: SignedInteger
    {
        if year.isInvalidYear ||
            month.isInvalidMonth ||
            day.isInvalidDay(inYear: year, month: month)
        {
            return nil
        }

        self.year = Int16(year)
        self.month = Int8(month)
        self.day = Int8(day)
    }
}

extension LocalDate {
    /// Create a `LocalDate` from an date segement of an [RFC 3339][] timestamp.
    /// Initialization will fail if the input does not comply with the format
    /// specified in [RFC 3339][].
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: The date potion of a timestamp conforming to
    ///                            the format specified in RFC 3339.
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    /// Create a `LocalDate` from an date segement of an [RFC 3339][] timestamp.
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

    /// Create a `LocalDate` from an date segement of an [RFC 3339][] timestamp.
    /// Initialization will fail if the input does not comply with the format
    /// specified in [RFC 3339][].
    ///
    /// [RFC 3339]: https://tools.ietf.org/html/rfc3339
    ///
    /// - Parameter rfc3339String: The date potion of a timestamp conforming to
    ///                            the format specified in RFC 3339. The content
    ///                            should be the same as argument of
    ///                            `init(rfc3339String:)`. Terminating `0` value
    ///                            from C strings should be excluded.
    public init?<S>(asciiValues: S) where S: RandomAccessCollection, S.Element == CChar, S.Index == Int {
        if asciiValues.count < 10 {
            return nil
        }

        if asciiValues[4] != dash || asciiValues[7] != dash {
            return nil
        }

        let asciiValues = asciiValues.map { $0 - zero }

        let year = Int16(asciiValues[0]) * 1000
            + Int16(asciiValues[1]) * 100
            + Int16(asciiValues[2]) * 10
            + Int16(asciiValues[3])
        if year.isInvalidYear {
            return nil
        }
        self.year = year

        let month = asciiValues[5] * 10 + asciiValues[6]
        if month.isInvalidMonth {
            return nil
        }
        self.month = month

        let day = asciiValues[8] * 10 + asciiValues[9]
        if day.isInvalidDay(inYear: year, month: month) {
            return nil
        }
        self.day = day
    }
}

extension LocalDate: CustomStringConvertible {
    /// Serialized description of `LocalDate` in RFC 3339 format.
    public var description: String {
        let yearString: String
        if self.year < 10 {
            yearString = "000\(self.year)"
        } else if year < 100 {
            yearString = "00\(self.year)"
        } else if year < 1000 {
            yearString = "0\(self.year)"
        } else {
            yearString = String(self.year)
        }
        let monthString = "\(self.month > 9 ? "" : "0")\(self.month)"
        let dayString = "\(self.day > 9 ? "" : "0")\(self.day)"
        return "\(yearString)-\(monthString)-\(dayString)"
    }
}
