import NetTime
import XCTest

final class TimeOffsetTests: XCTestCase {
    func testValidation() {
        XCTAssertNotNil(TimeOffset(sign: .plus, hour: 0, minute: 0))
        XCTAssertNotNil(TimeOffset(sign: .plus, hour: 0, minute: 59))
        XCTAssertNotNil(TimeOffset(sign: .minus, hour: 23, minute: 59))
        XCTAssertNotNil(TimeOffset(sign: .minus, hour: 23, minute: 0))
    }

    func testInvalidation() {
        XCTAssertNil(TimeOffset(sign: .plus, hour: -1, minute: 0))
        XCTAssertNil(TimeOffset(sign: .plus, hour: 0, minute: -1))
        XCTAssertNil(TimeOffset(sign: .minus, hour: 24, minute: 59))
        XCTAssertNil(TimeOffset(sign: .minus, hour: 23, minute: 60))
    }

    func testSerialization() {
        XCTAssertEqual(
            TimeOffset(sign: .plus, hour: 0, minute: 0)?.description,
            "Z"
        )

        XCTAssertEqual(
            TimeOffset(sign: .plus, hour: 0, minute: 59)?.description,
            "+00:59"
        )
    }

    func testDeserialization() {
        XCTAssertEqual(
            TimeOffset(rfc3339String: "Z"),
            TimeOffset(sign: .plus, hour: 0, minute: 0)
        )

        XCTAssertEqual(
            TimeOffset(rfc3339String: "z"),
            TimeOffset(sign: .plus, hour: 0, minute: 0)
        )

        XCTAssertEqual(
            TimeOffset(rfc3339String: "-59:01"),
            TimeOffset(sign: .minus, hour: 59, minute: 1)
        )
    }

    func testConvertingToSeconds() {
        XCTAssertEqual(TimeOffset(sign: .minus, hour: 0, minute: 1)?.asSeconds, -60)
        XCTAssertEqual(TimeOffset(sign: .plus, hour: 1, minute: 0)?.asSeconds, 3600)
    }
}
