public struct LocalDateTime: Equatable {
    public var date: LocalDate
    public var time: LocalTime

    public init(date: LocalDate, time: LocalTime) {
        self.date = date
        self.time = time
    }
}

extension LocalDateTime: DateTimeRepresentable {}

extension LocalDateTime {
    public init?(rfc3339String: String) {
        self.init(asciiValues: Array(rfc3339String.utf8CString.dropLast()))
    }

    public init(staticRFC3339String string: StaticString) {
        self.init(rfc3339String: string.description)!
    }

    init?(asciiValues: [Int8]) {
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
    public var description: String {
        return "\(self.date)T\(self.time)"
    }
}
