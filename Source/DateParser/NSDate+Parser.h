@import Foundation;

static NSString * const DateParserDateNoTimestampFormat = @"YYYY-MM-DD";
static NSString * const DateParserTimestamp = @"T00:00:00+00:00";

typedef NS_ENUM(NSInteger, DateType) {
    iso8601,
    unixTimestamp
};

@interface NSDate (Parser)

+ (NSDate *)dateFromDateString:(NSString *)dateString;

// needs unit tests
+ (NSDate *)dateFromUnixTimestampString:(NSString *)unixTimestamp;

/*
 unixTimestamp shouldn't be more than NSIntegerMax (2,147,483,647)
 */
+ (NSDate *)dateFromUnixTimestampNumber:(NSNumber *)unixTimestamp;

// needs unit tests
+ (NSDate *)dateFromISO8601String:(NSString *)iso8601;

@end

@interface NSString (Parser)

- (DateType)dateType;

@end
