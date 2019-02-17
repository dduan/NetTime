import NetTime
import XCTest

final class LocalDateTimeTests: XCTestCase {
    func testGetters() {
        let date = LocalDate(year: 2018, month: 2, day: 17)!
        let time = LocalTime(hour: 2, minute: 22, second: 55)!
        let dateTime = LocalDateTime(date: date, time: time)

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
        var dateTime = LocalDateTime(date: date, time: time)

        dateTime.year = 2019
        dateTime.month = 3
        dateTime.day = 18
        dateTime.hour = 3
        dateTime.minute = 23
        dateTime.second = 56

        let newDateTime = LocalDateTime(
            date: LocalDate(year: 2019, month: 3, day: 18)!,
            time: LocalTime(hour: 3, minute: 23, second: 56)!
        )

        XCTAssertEqual(dateTime, newDateTime)
    }

    func testSerialization() {
        let date = LocalDate(year: 2018, month: 2, day: 17)!
        let time = LocalTime(hour: 2, minute: 22, second: 55)!
        let dateTime = LocalDateTime(date: date, time: time)
        XCTAssertEqual(dateTime.description, "2018-02-17T02:22:55")

        let time2 = LocalTime(hour: 2, minute: 22, second: 55, secondFraction: [1, 2, 3])!
        let dateTime2 = LocalDateTime(date: date, time: time2)
        XCTAssertEqual(dateTime2.description, "2018-02-17T02:22:55.123")
    }

    func testDeserialization() {
        let date = LocalDate(year: 2018, month: 2, day: 17)!
        let time = LocalTime(hour: 2, minute: 22, second: 55)!
        let dateTime = LocalDateTime(date: date, time: time)
        XCTAssertEqual(LocalDateTime(rfc3339String: "2018-02-17T02:22:55"), dateTime)

        let time2 = LocalTime(hour: 2, minute: 22, second: 55, secondFraction: [1, 2, 3])!
        let dateTime2 = LocalDateTime(date: date, time: time2)
        XCTAssertEqual(LocalDateTime(rfc3339String: "2018-02-17T02:22:55.123"), dateTime2)
    }
}
