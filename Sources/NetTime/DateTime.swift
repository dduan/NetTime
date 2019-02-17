public struct DateTime: Equatable {
    public var date: LocalDate
    public var time: LocalTime
    public var utcOffset: TimeOffset

    public init(date: LocalDate, time: LocalTime, utcOffset: TimeOffset = .zero) {
        self.date = date
        self.time = time
        self.utcOffset = utcOffset
    }
}

extension DateTime: DateTimeRepresentable {}

extension DateTime {
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    public init(staticRFC3339String string: StaticString) {
        self.init(rfc3339String: string.description)!
    }

    init?(asciiValues: [Int8]) {
        guard asciiValues.count == 20
            || asciiValues.count == 25
            || asciiValues.count > 26,
            let date = LocalDate(asciiValues: Array(asciiValues[0 ..< 10])),
            let time = LocalTime(asciiValues: Array(asciiValues[11...])),
            case let timezoneStart = time.secondFraction.count + 19 + (time.secondFraction.isEmpty ? 0 : 1),
            let offset = TimeOffset(asciiValues: Array(asciiValues[timezoneStart...]))
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
    public var timeIntervalSince1970: Double {
        var time = tm()
        time.tm_year = Int32(self.year - 1900)
        time.tm_mon = Int32(self.month) - 1
        time.tm_mday = Int32(self.day)
        time.tm_hour = Int32(self.hour)
        time.tm_min = Int32(self.minute)
        time.tm_sec = Int32(self.second)


        let localSeconds = mktime(&time)
        let wholeSeconds = Double(localSeconds - self.utcOffset.asSeconds + time.tm_gmtoff)
        let fraction: Double = self.time.secondFraction.reversed().reduce(0) { ($0 + Double($1)) / 10 }
        return wholeSeconds + fraction
    }
}
