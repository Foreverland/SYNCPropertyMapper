@import Foundation;

static NSString * const HYPPropertyMapperDateNoTimestampFormat = @"YYYY-MM-DD";
static NSString * const HYPPropertyMapperTimestamp = @"T00:00:00+00:00";

typedef NS_ENUM(NSInteger, HYPDateType) {
    HYPDateTypeISO8601,
    HYPDateTypeUnixTimestamp
};

@interface NSDate (HYPPropertyMapperDateHandling)

+ (NSDate *)hyp_dateFromDateString:(NSString *)dateString;

+ (NSDate *)hyp_dateFromUnixTimestampString:(NSString *)unixTimestamp;

/*
 unixTimestamp shouldn't be more than NSIntegerMax (2,147,483,647)
 */
+ (NSDate *)hyp_dateFromUnixTimestampNumber:(NSNumber *)unixTimestamp;

+ (NSDate *)hyp_dateFromISO8601String:(NSString *)iso8601;

@end

@interface NSString (HYPPropertyMapperDateHandling)

- (HYPDateType)hyp_dateType;

@end
