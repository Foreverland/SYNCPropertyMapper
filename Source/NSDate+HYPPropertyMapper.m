#import "NSDate+HYPPropertyMapper.h"

@implementation NSDate (HYPPropertyMapper)

+ (NSDate *)hyp_dateFromISO8601String:(NSString *)iso8601 {
    if (!iso8601 || [iso8601 isEqual:[NSNull null]]) {
        return nil;
    }

    // Parse number
    if ([iso8601 isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)iso8601 doubleValue]];
    }

    // Parse string
    else if ([iso8601 isKindOfClass:[NSString class]]) {
        if ([iso8601 length] == [HYPPropertyMapperDateNoTimestampFormat length]) {
            NSMutableString *mutableRemoteValue = [iso8601 mutableCopy];
            [mutableRemoteValue appendString:HYPPropertyMapperTimestamp];
            iso8601 = [mutableRemoteValue copy];
        }

        const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
        size_t len = strlen(str);
        if (len == 0) {
            return nil;
        }

        struct tm tm;
        char newStr[25] = "";
        BOOL hasTimezone = NO;

        // 2014-03-30T09:13:00Z
        if (len == 20 && str[len - 1] == 'Z') {
            strncpy(newStr, str, len - 1);
        }

        // 2014-03-30T09:13:00-07:00
        else if (len == 25 && str[22] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
        }

        // 2014-03-30T09:13:00.000Z
        else if (len == 24 && str[len - 1] == 'Z') {
            strncpy(newStr, str, 19);
        }

        // 2015-06-23T12:40:08.000+02:00
        else if (len == 29 && str[26] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
        }

        // 2015-08-23T09:29:30.007450+00:00
        else if (len == 32 && str[29] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
        }

        // 2015-09-10T13:47:21.116+0000
        else if (len == 28 && str[23] == '+') {
            strncpy(newStr, str, 19);
            hasTimezone = NO;
        }

        // Poorly formatted timezone
        else {
            strncpy(newStr, str, len > 24 ? 24 : len);
        }

        // Timezone
        size_t l = strlen(newStr);
        if (hasTimezone) {
            strncpy(newStr + l, str + len - 6, 3);
            strncpy(newStr + l + 3, str + len - 2, 2);
        } else {
            strncpy(newStr + l, "+0000", 5);
        }

        // Add null terminator
        newStr[sizeof(newStr) - 1] = 0;

        if (strptime(newStr, "%FT%T%z", &tm) == NULL) {
            return nil;
        }

        time_t t;
        t = mktime(&tm);

        return [NSDate dateWithTimeIntervalSince1970:t];
    }

    NSAssert1(NO, @"Failed to parse date: %@", iso8601);
    return nil;
}

@end
