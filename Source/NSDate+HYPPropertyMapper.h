@import Foundation;

static NSString * const HYPPropertyMapperDateNoTimestampFormat = @"YYYY-MM-DD";
static NSString * const HYPPropertyMapperTimestamp = @"T00:00:00+00:00";

@interface NSDate (HYPPropertyMapper)

+ (NSDate *)hyp_dateFromDateString:(NSString *)dateString;

+ (NSDate *)hyp_dateFromISO8601String:(NSString *)iso8601 __attribute__((deprecated("Use hyp_dateFromDateString: instead")));

@end
