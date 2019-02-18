import NetTime
import XCTest

final class DateTimeTests: XCTestCase {
    func testGetters() {
        let date = LocalDate(year: 2018, month: 2, day: 17)!
        let time = LocalTime(hour: 2, minute: 22, second: 55)!
        let offset = TimeOffset(sign: .plus, hour: 02, minute: 02)!
        let dateTime = DateTime(date: date, time: time, utcOffset: offset)

        XCTAssertEqual(dateTime.year, 2018)
        XCTAssertEqual(dateTime.month, 2)
        XCTAssertEqual(dateTime.day, 17)
        XCTAssertEqual(dateTime.hour, 2)
        XCTAssertEqual(dateTime.minute, 22)
        XCTAssertEqual(dateTime.second, 55)
    }

    func testSetters() {
        let date = LocalDate(year: 2018, month: 2, day: 17)!
        let time = LocalTime(hour: 2, minute: 22, second: 55)!
        let offset = TimeOffset(sign: .plus, hour: 02, minute: 02)!
        var dateTime = DateTime(date: date, time: time, utcOffset: offset)

        dateTime.year = 2019
        dateTime.month = 3
        dateTime.day = 18
        dateTime.hour = 3
        dateTime.minute = 23
        dateTime.second = 56

        let newDateTime = DateTime(
            date: LocalDate(year: 2019, month: 3, day: 18)!,
            time: LocalTime(hour: 3, minute: 23, second: 56)!,
            utcOffset: offset
        )

        XCTAssertEqual(dateTime, newDateTime)
    }

    func testSerialization() {
        let date = LocalDate(year: 2018, month: 2, day: 17)!
        let time = LocalTime(hour: 2, minute: 22, second: 55)!
        let offset = TimeOffset(sign: .minus, hour: 02, minute: 02)!
        let dateTime = DateTime(date: date, time: time, utcOffset: offset)
        XCTAssertEqual(dateTime.description, "2018-02-17T02:22:55-02:02")

        let time2 = LocalTime(hour: 2, minute: 22, second: 55, secondFraction: [1, 2, 3])!
        let dateTime2 = DateTime(date: date, time: time2)
        XCTAssertEqual(dateTime2.description, "2018-02-17T02:22:55.123Z")
    }

    func testDeserialization() {
        let date = LocalDate(year: 2018, month: 2, day: 17)!
        let time = LocalTime(hour: 2, minute: 22, second: 55)!
        let dateTime = DateTime(date: date, time: time)
        XCTAssertEqual(DateTime(rfc3339String: "2018-02-17T02:22:55Z"), dateTime)

        let time2 = LocalTime(hour: 2, minute: 22, second: 55, secondFraction: [1, 2, 3])!
        let offset = TimeOffset(sign: .plus, hour: 02, minute: 02)!
        let dateTime2 = DateTime(date: date, time: time2, utcOffset: offset)
        XCTAssertEqual(DateTime(rfc3339String: "2018-02-17T02:22:55.123+02:02"), dateTime2)
    }

    func testConvertingEpochToInterval() {
        let moment = DateTime(staticRFC3339String: "1970-01-01T00:00:00+00:00")
        XCTAssertEqual(moment.timeIntervalSince1970, 0)
    }

    func testConvertingEpochWithOffsetToInterval() {
        let moment = DateTime(staticRFC3339String: "1970-01-01T00:01:00+00:01")
        XCTAssertEqual(moment.timeIntervalSince1970, 0)
    }

    func testConvertingMomentToInterval() {
        let moment = DateTime(staticRFC3339String: "1970-01-01T01:01:00.123+00:01")
        XCTAssertEqual(moment.timeIntervalSince1970, 3600.123, accuracy: 0.0001)
    }

    func testConvertingNSDateEpochToInterval() {
        let moment = DateTime(staticRFC3339String: "2001-01-01T00:00:00+00:00")
        XCTAssertEqual(moment.timeIntervalSince2001, 0)
    }

    func testConvertingNSDateWithOffsetEpochToInterval() {
        let moment = DateTime(staticRFC3339String: "2001-01-01T00:01:00+00:01")
        XCTAssertEqual(moment.timeIntervalSince2001, 0)
    }

    func testConvertingNSDateMomentToInterval() {
        let moment = DateTime(staticRFC3339String: "2001-01-01T01:01:00.123+00:01")
        XCTAssertEqual(moment.timeIntervalSince2001, 3600.123, accuracy: 0.0001)
    }
}
