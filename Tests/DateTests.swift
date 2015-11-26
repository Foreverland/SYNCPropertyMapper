import XCTest

import NSManagedObject_HYPPropertyMapper

class DateTests: XCTestCase {
    func testDateA() {
        let date = NSDate.dateWithHourAndTimeZoneString("2015-06-23T12:40:08.000")
        let resultDate = NSDate.hyp_dateFromDateString("2015-06-23T12:40:08.000+02:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqualWithAccuracy(resultDate.timeIntervalSinceReferenceDate, date.timeIntervalSinceReferenceDate, accuracy: 1.0)
    }

    func testDateB() {
        let date = NSDate.dateWithDayString("2014-01-01")
        let resultDate = NSDate.hyp_dateFromDateString("2014-01-01T00:00:00+00:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateC() {
        let date = NSDate.dateWithDayString("2014-01-02")
        let resultDate = NSDate.hyp_dateFromDateString("2014-01-02")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateD() {
        let date = NSDate.dateWithDayString("2014-01-02")
        let resultDate = NSDate.hyp_dateFromDateString("2014-01-02T00:00:00.007450+00:00")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateE() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate.hyp_dateFromDateString("2015-09-10T00:00:00.116+0000")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateF() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate.hyp_dateFromDateString("2015-09-10T00:00:00.184968Z")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampA() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate.hyp_dateFromDateString("1441843200")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampB() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate.hyp_dateFromDateString("1441843200000000")

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampC() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate.hyp_dateFromUnixTimestampNumber(1441843200)

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testTimestampD() {
        let date = NSDate.dateWithDayString("2015-09-10")
        let resultDate = NSDate.hyp_dateFromUnixTimestampNumber(1441843200000000)

        XCTAssertNotNil(resultDate)
        XCTAssertEqual(date, resultDate)
    }

    func testDateType() {
        let isoDateType = "2014-01-02T00:00:00.007450+00:00".hyp_dateType()
        XCTAssertEqual(isoDateType, HYPDateType.ISO8601)

        let timestampDateType = "1441843200000000".hyp_dateType()
        XCTAssertEqual(timestampDateType, HYPDateType.UnixTimestamp)
    }
}

extension NSDate {
    static func dateWithDayString(dateString: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "GMT")
        let date = formatter.dateFromString(dateString)!

        return date
    }

    static func dateWithHourAndTimeZoneString(dateString: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 2 * 60 * 60)
        let date = formatter.dateFromString(dateString)!

        return date
    }
}
