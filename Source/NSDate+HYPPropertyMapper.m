#import "NSDate+HYPPropertyMapper.h"

@implementation NSDate (HYPPropertyMapperDateHandling)

+ (NSDate *)hyp_dateFromDateString:(NSString *)dateString {
    NSDate *parsedDate = nil;

    HYPDateType dateType = [dateString hyp_dateType];
    switch (dateType) {
        case HYPDateTypeISO8601: {
            parsedDate = [self hyp_dateFromISO8601String:dateString];
        } break;
        case HYPDateTypeUnixTimestamp: {
            parsedDate = [self hyp_dateFromUnixTimestampString:dateString];
        } break;
        default: break;
    }

    return parsedDate;
}

+ (NSDate *)hyp_dateFromISO8601String:(NSString *)dateString {
    if (!dateString || [dateString isEqual:[NSNull null]]) {
        return nil;
    }

    // Parse string
    else if ([dateString isKindOfClass:[NSString class]]) {
        if ([dateString length] == [HYPPropertyMapperDateNoTimestampFormat length]) {
            NSMutableString *mutableRemoteValue = [dateString mutableCopy];
            [mutableRemoteValue appendString:HYPPropertyMapperTimestamp];
            dateString = [mutableRemoteValue copy];
        }

        const char *str = [dateString cStringUsingEncoding:NSUTF8StringEncoding];
        size_t length = strlen(str);
        if (length == 0) {
            return nil;
        }

        struct tm tm;
        char newStr[25] = "";
        BOOL hasTimezone = NO;

        NSLog(@"dateString: %@", dateString);

        // Copy all the date excluding the Z.
        // The date: 2014-03-30T09:13:00Z
        // Will become: 2014-03-30T09:13:00
        // Unit test H
        if (length == 20 && str[length - 1] == 'Z') {
            strncpy(newStr, str, length - 1);
        }

        // Copy all the date excluding the timezone also set `hasTimezone` to YES.
        // The date: 2014-01-01T00:00:00+00:00
        // Will become: 2014-01-01T00:00:00
        // Unit test B and C
        else if (length == 25 && str[22] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
            printf("newStr: %s\n\n", newStr);
        }

        // Copy all the date excluding the miliseconds and the Z.
        // The date: 2014-03-30T09:13:00.000Z
        // Will become: 2014-03-30T09:13:00
        // Unit test G
        else if (length == 24 && str[length - 1] == 'Z') {
            strncpy(newStr, str, 19);
            printf("newStr: %s\n\n", newStr);
        }

        // Copy all the date excluding the miliseconds and the timezone also set `hasTimezone` to YES.
        // The date: 2015-06-23T12:40:08.000+02:00
        // Will become: 2015-06-23T12:40:08
        // Unit test A
        else if (length == 29 && str[26] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
            printf("newStr: %s\n\n", newStr);
        }

        // Copy all the date excluding the microseconds and the timezone also set `hasTimezone` to YES.
        // The date: 2015-08-23T09:29:30.007450+00:00
        // Will become: 2015-08-23T09:29:30
        // Unit test D
        else if (length == 32 && str[29] == ':') {
            strncpy(newStr, str, 19);
            hasTimezone = YES;
            printf("newStr: %s\n\n", newStr);
        }

        // Copy all the date excluding the microseconds and the timezone.
        // The date: 2015-09-10T13:47:21.116+0000
        // Will become: 2015-09-10T13:47:21
        // Unit test E
        else if (length == 28 && str[23] == '+') {
            strncpy(newStr, str, 19);
            printf("newStr: %s\n\n", newStr);
        }

        // Copy all the date excluding the microseconds and the Z.
        // The date: 2015-09-10T00:00:00.184968Z
        // Will become: 2015-09-10T00:00:00
        // Unit test F
        else if (str[19] == '.' && str[length - 1] == 'Z') {
            strncpy(newStr, str, 19);
            printf("newStr: %s\n\n", newStr);
        }

        // Poorly formatted timezone
        else {
            strncpy(newStr, str, length > 24 ? 24 : length);
            printf("newStr: %s\n\n", newStr);
        }

        // Timezone
        size_t l = strlen(newStr);
        if (hasTimezone) {
            // Add the removed timezone to the end of the string.
            // The date: 2015-06-23T14:40:08
            // Will become: 2015-06-23T14:40:08+0200
            strncpy(newStr + l, str + length - 6, 3);
            strncpy(newStr + l + 3, str + length - 2, 2);
            printf("newStr: %s\n\n", newStr);
        } else {
            // Add GMT timezone to the end of the string
            // The date: 2015-09-10T00:00:00
            // Will become: 2015-09-10T00:00:00+0000
            strncpy(newStr + l, "+0000", 5);
            printf("newStr: %s\n\n", newStr);
        }

        // Add null terminator
        newStr[sizeof(newStr) - 1] = 0;

        // Parse the formatted date using `strptime`.
        // %F: Equivalent to %Y-%m-%d, the ISO 8601 date format
        //  T: The date, time separator
        // %T: Equivalent to %H:%M:%S
        // %z: An RFC-822/ISO 8601 standard timezone specification
        if (strptime(newStr, "%FT%T%z", &tm) == NULL) {
            return nil;
        }

        time_t t;
        t = mktime(&tm);

        return [NSDate dateWithTimeIntervalSince1970:t];
    }

    NSAssert1(NO, @"Failed to parse date: %@", dateString);
    return nil;
}

+ (NSDate *)hyp_dateFromUnixTimestampNumber:(NSNumber *)unixTimestamp {
    return [self hyp_dateFromUnixTimestampString:[unixTimestamp stringValue]];
}

+ (NSDate *)hyp_dateFromUnixTimestampString:(NSString *)unixTimestamp {
    NSString *parsedString = unixTimestamp;

    NSString *validUnixTimestamp = @"1441843200";
    NSInteger validLength = [validUnixTimestamp length];
    if ([unixTimestamp length] > validLength) {
        parsedString = [unixTimestamp substringToIndex:validLength];
    }

    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *unixTimestampNumber = [numberFormatter numberFromString:parsedString];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:unixTimestampNumber.doubleValue];

    return date;
}

@end

@implementation NSString (HYPPropertyMapperDateHandling)

- (HYPDateType)hyp_dateType {
    if ([self containsString:@"-"]) {
        return HYPDateTypeISO8601;
    } else {
        return HYPDateTypeUnixTimestamp;
    }
}

@end
