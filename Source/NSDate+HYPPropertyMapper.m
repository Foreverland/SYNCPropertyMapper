#import "NSDate+HYPPropertyMapper.h"

@implementation NSDate (HYPPropertyMapper)

+ (NSDate *)hyp_dateFromISO8601String:(NSString *)iso8601 {
    if (!iso8601 || [iso8601 isEqual:[NSNull null]]) return nil;

    if ([iso8601 isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)iso8601 doubleValue]];
    } else if ([iso8601 isKindOfClass:[NSString class]]) {

        if (!iso8601) return nil;

        const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
        char newStr[25];

        struct tm tm;
        size_t len = strlen(str);

        if (len == 0) return nil;

        BOOL UTC = (len == 20 && str[len - 1] == 'Z');
        BOOL miliseconds = (len == 24 && str[len - 1] == 'Z');
        BOOL timezone = (len == 25 && str[22] == ':');
        if (UTC) {
            strncpy(newStr, str, len - 1);
            strncpy(newStr + len - 1, "+0000", 5);
        } else if (miliseconds) {
            strncpy(newStr, str, len - 1);
            strncpy(newStr, str, len - 5);
            strncpy(newStr + len - 5, "+0000", 5);
        } else if (timezone) {
            strncpy(newStr, str, 22);
            strncpy(newStr + 22, str + 23, 2);
        } else {
            strncpy(newStr, str, len > 24 ? 24 : len);
        }

        newStr[sizeof(newStr) - 1] = 0;

        if (strptime(newStr, "%FT%T%z", &tm) == NULL) return nil;

        time_t t;
        t = mktime(&tm);

        NSDate *returnedDate = [NSDate dateWithTimeIntervalSince1970:t];
        return returnedDate;
    }

    NSAssert1(NO, @"Failed to parse date: %@", iso8601);
    return nil;
}

@end
