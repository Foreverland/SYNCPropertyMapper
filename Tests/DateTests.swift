import XCTest

import NSManagedObject_HYPPropertyMapper

class DateTests: XCTestCase {
    func testDateA() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 2 * 60 * 60)

        let date = formatter.dateFromString("2015-06-23T12:40:08.000")
        let resultDate = NSDate.hyp_dateFromISO8601String("2015-06-23T12:40:08.000+02:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqualWithAccuracy(resultDate.timeIntervalSinceReferenceDate, date!.timeIntervalSinceReferenceDate, accuracy: 1.0)
    }

    func testDateB() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "GMT")

        let date = formatter.dateFromString("2014-01-01")
        let resultDate = NSDate.hyp_dateFromISO8601String("2014-01-01T00:00:00+00:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateC() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "GMT")

        let date = formatter.dateFromString("2014-01-02")
        let resultDate = NSDate.hyp_dateFromISO8601String("2014-01-02")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateD() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "GMT")

        let date = formatter.dateFromString("2014-01-02")
        let resultDate = NSDate.hyp_dateFromISO8601String("2014-01-02T00:00:00.007450+00:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateE() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "GMT")

        let date = formatter.dateFromString("2015-09-10")
        let resultDate = NSDate.hyp_dateFromISO8601String("2015-09-10T00:00:00.116+0000")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }
}
