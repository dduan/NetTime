/// A type that represents date and time (but not necessarily offset to UTC).
public protocol DateTimeRepresentable {
    /// Year, month, day potion of the moment.
    var date: LocalDate { get set }
    /// Hour, minute, second, sub-second potion of the moment.
    var time: LocalTime { get set }
}

extension DateTimeRepresentable {
    /// The year.
    public var year: Int16 {
        get { return self.date.year }
        set { return self.date.year = newValue }
    }

    /// The month.
    public var month: Int8 {
        get { return self.date.month }
        set { return self.date.month = newValue }
    }

    /// The day.
    public var day: Int8 {
        get { return self.date.day }
        set { return self.date.day = newValue }
    }

    /// The hour.
    public var hour: Int8 {
        get { return self.time.hour }
        set { return self.time.hour = newValue }
    }

    /// The minute.
    public var minute: Int8 {
        get { return self.time.minute }
        set { return self.time.minute = newValue }
    }

    /// The second.
    public var second: Int8 {
        get { return self.time.second }
        set { return self.time.second = newValue }
    }
}
