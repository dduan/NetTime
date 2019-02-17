public protocol DateTimeRepresentable {
    var date: LocalDate { get set }
    var time: LocalTime { get set }
}

extension DateTimeRepresentable {
    public var year: Int16 {
        get { return self.date.year }
        set { return self.date.year = newValue }
    }

    public var month: Int8 {
        get { return self.date.month }
        set { return self.date.month = newValue }
    }

    public var day: Int8 {
        get { return self.date.day }
        set { return self.date.day = newValue }
    }

    public var hour: Int8 {
        get { return self.time.hour }
        set { return self.time.hour = newValue }
    }

    public var minute: Int8 {
        get { return self.time.minute }
        set { return self.time.minute = newValue }
    }

    public var second: Int8 {
        get { return self.time.second }
        set { return self.time.second = newValue }
    }
}
