@import XCTest;

#import "NSDate+HYPPropertyMapper.h"

@interface DateTests : XCTestCase

@end

@implementation DateTests

- (void)testDateA {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    dateFormat.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:2 * 60 * 60];

    NSDate *date = [dateFormat dateFromString:@"2015-06-23T12:40:08.000"];
    NSDate *resultDate = [NSDate hyp_dateFromISO8601String:@"2015-06-23T12:40:08.000+02:00"];

    XCTAssertNotNil(resultDate);
    XCTAssertEqualWithAccuracy([resultDate timeIntervalSinceReferenceDate], date.timeIntervalSinceReferenceDate, 1.);
}

- (void)testDateB {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];

    NSDate *date = [NSDate hyp_dateFromISO8601String:@"2014-01-01T00:00:00+00:00"];
    NSDate *resultDate = [dateFormat dateFromString:@"2014-01-01"];

    XCTAssertEqualObjects(resultDate, date);
}

- (void)testDateC {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];

    NSDate *date = [NSDate hyp_dateFromISO8601String:@"2014-01-02"];
    NSDate *resultDate = [dateFormat dateFromString:@"2014-01-02"];

    XCTAssertEqualObjects(resultDate, date);
}

- (void)testDateD {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];

    NSDate *date = [NSDate hyp_dateFromISO8601String:@"2014-01-02T00:00:00.007450+00:00"];
    NSDate *resultDate = [dateFormat dateFromString:@"2014-01-02"];

    XCTAssertEqualObjects(resultDate, date);
}

- (void)testDateE {
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];

    NSDate *date = [NSDate hyp_dateFromISO8601String:@"2015-09-10T00:00:00.116+0000"];
    NSDate *resultDate = [dateFormat dateFromString:@"2015-09-10"];

    XCTAssertEqualObjects(resultDate, date);
}

@end
