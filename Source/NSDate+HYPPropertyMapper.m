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

        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];

        const char *str = [dateString cStringUsingEncoding:NSUTF8StringEncoding];
        size_t len = strlen(str);
        if (len == 0) {
            return nil;
        }

        // 2014-03-30T09:13:00Z
        if (len == 20 && str[len - 1] == 'Z') {
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        }

        // 2014-03-30T09:13:00-07:00
        else if (len == 25 && str[22] == ':') {
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
        }

        // 2014-03-30T09:13:00.000Z
        else if (len == 24 && str[len - 1] == 'Z') {
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        }

        // 2015-06-23T12:40:08.000+02:00
        else if (len == 29 && str[26] == ':') {
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ";
        }

        // 2015-08-23T09:29:30.007450+00:00
        else if (len == 32 && str[29] == ':') {
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ";
        }

        // 2015-09-10T13:47:21.116+0000
        else if (len == 28 && str[23] == '+') {
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ";
        }

        // Poorly formatted timezone
        else {
            if (dateString.length > 19) {
                dateString = [[dateString substringToIndex:18] stringByAppendingString:@"Z"];
            }
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
        }

        return [dateFormatter dateFromString:dateString];
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
