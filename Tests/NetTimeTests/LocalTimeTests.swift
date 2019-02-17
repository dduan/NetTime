import NetTime
import XCTest

final class LocalTimeTests: XCTestCase {
    func testInitValidation() {
        XCTAssertNotNil(LocalTime(hour: 23, minute: 59, second: 59))
        XCTAssertNotNil(LocalTime(hour: 0, minute: 0, second: 60))
        XCTAssertNotNil(LocalTime(hour: 0, minute: 0, second: 0))
        XCTAssertNotNil(LocalTime(hour: 0, minute: 0, second: 0, secondFraction: [0, 9, 0, 9]))
    }

    func testInitInvalidation() {
        XCTAssertNil(LocalTime(hour: -1, minute: 59, second: 59))
        XCTAssertNil(LocalTime(hour: 24, minute: 59, second: 59))
        XCTAssertNil(LocalTime(hour: 23, minute: -1, second: 59))
        XCTAssertNil(LocalTime(hour: 23, minute: 60, second: 59))
        XCTAssertNil(LocalTime(hour: 23, minute: 59, second: -1))
        XCTAssertNil(LocalTime(hour: 23, minute: 59, second: 61))
        XCTAssertNil(LocalTime(hour: 0, minute: 0, second: 0, secondFraction: [10, 0]))
    }

    func testSerialization() {
        XCTAssertEqual(
            LocalTime(hour: 23, minute: 59, second: 59)?.description,
            "23:59:59"
        )

        XCTAssertEqual(
            LocalTime(hour: 23, minute: 59, second: 59, secondFraction: [0, 9, 0, 9])?.description,
            "23:59:59.0909"
        )
    }

    func testDeserialization() {
        XCTAssertEqual(
            LocalTime(rfc3339String: "23:59:59"),
            LocalTime(hour: 23, minute: 59, second: 59)
        )

        XCTAssertEqual(
            LocalTime(rfc3339String: "23:59:59.0909"),
            LocalTime(hour: 23, minute: 59, second: 59, secondFraction: [0, 9, 0, 9])
        )
    }
}
