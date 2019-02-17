import NetTime
import XCTest

final class LocalDateTests: XCTestCase {
    func testInitValidation() {
        XCTAssertNotNil(LocalDate(year: 2019, month: 2, day: 17))
        XCTAssertNotNil(LocalDate(year: 2016, month: 2, day: 29))
        XCTAssertNotNil(LocalDate(year: 9999, month: 12, day: 31))
        XCTAssertNotNil(LocalDate(year: 1, month: 1, day: 1))
    }

    func testInitInvalidation() {
        XCTAssertNil(LocalDate(year: 2019, month: 2, day: 29))
        XCTAssertNil(LocalDate(year: -1, month: 2, day: 28))
        XCTAssertNil(LocalDate(year: 9999, month: 13, day: 31))
        XCTAssertNil(LocalDate(year: 0, month: 4, day: 31))
    }

    func testSerialization() {
        XCTAssertEqual(
            LocalDate(year: 2019, month: 2, day: 17)?.description,
            "2019-02-17"
        )
        XCTAssertEqual(
            LocalDate(year: 1, month: 1, day: 1)?.description,
            "0001-01-01"
        )
    }

    func testDeserialization() {
        XCTAssertEqual(
            LocalDate(rfc3339String: "2019-02-17"),
            LocalDate(year: 2019, month: 2, day: 17)
        )

        XCTAssertEqual(
            LocalDate(rfc3339String: "0001-01-01"),
            LocalDate(year: 1, month: 1, day: 1)
        )
    }
}
