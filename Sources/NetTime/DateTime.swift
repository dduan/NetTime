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
