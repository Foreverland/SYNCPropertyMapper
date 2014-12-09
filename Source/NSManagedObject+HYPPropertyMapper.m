#import "NSManagedObject+HYPPropertyMapper.h"

@implementation NSString (PrivateInflections)

#pragma mark - Private methods

- (NSString *)hyp_remoteString
{
    NSString *processedString = [self hyp_replacementIdentifier:@"_"];

    if ([processedString hyp_containsWord:@"date"]) {
        NSString *replacedString = [processedString stringByReplacingOccurrencesOfString:@"_date"
                                                                              withString:@"_at"];
        if ([[NSString hyp_dateAttributes] containsObject:replacedString]) {
            processedString = replacedString;
        }
    }

    return [processedString hyp_lowerCaseFirstLetter];
}

- (NSString *)hyp_localString
{
    NSString *processedString = self;

    if ([self hyp_containsWord:@"at"]) {
        processedString = [self stringByReplacingOccurrencesOfString:@"_at"
                                                          withString:@"_date"];
    }

    processedString = [processedString hyp_replacementIdentifier:@""];

    BOOL remoteStringIsAnAcronym = ([[NSString hyp_acronyms] containsObject:[processedString lowercaseString]]);

    return (remoteStringIsAnAcronym) ? [processedString lowercaseString] : [processedString hyp_lowerCaseFirstLetter];
}

- (BOOL)hyp_containsWord:(NSString *)word
{
    BOOL found = NO;

    NSArray *components = [self componentsSeparatedByString:@"_"];

    for (NSString *component in components) {
        if ([component isEqualToString:word]) {
            found = YES;
            break;
        }
    }

    return found;
}

- (NSString *)hyp_lowerCaseFirstLetter
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:self];
    NSString *firstLetter = [[mutableString substringToIndex:1] lowercaseString];
    [mutableString replaceCharactersInRange:NSMakeRange(0,1)
                                 withString:firstLetter];

    return [mutableString copy];
}

- (NSString *)hyp_replacementIdentifier:(NSString *)replacementString
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    scanner.caseSensitive = YES;

    NSCharacterSet *identifierSet   = [NSCharacterSet characterSetWithCharactersInString:@"_- "];
    NSCharacterSet *alphanumericSet = [NSCharacterSet alphanumericCharacterSet];
    NSCharacterSet *uppercaseSet    = [NSCharacterSet uppercaseLetterCharacterSet];
    NSCharacterSet *lowercaseSet    = [NSCharacterSet lowercaseLetterCharacterSet];

    NSString *buffer;
    NSMutableString *output = [NSMutableString string];

    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:identifierSet intoString:&buffer]) {
            continue;
        }

        if (replacementString.length > 0) {
            if ([scanner scanCharactersFromSet:uppercaseSet intoString:&buffer]) {

                if (output.length > 0) {
                    [output appendString:replacementString];
                }

                [output appendString:[buffer lowercaseString]];
            }
            if ([scanner scanCharactersFromSet:lowercaseSet intoString:&buffer]) {
                [output appendString:[buffer lowercaseString]];
            }
        } else {
            if ([scanner scanCharactersFromSet:alphanumericSet intoString:&buffer]) {
                if ([[NSString hyp_acronyms] containsObject:buffer]) {
                    [output appendString:[buffer uppercaseString]];
                } else {
                    [output appendString:[buffer capitalizedString]];
                }
            }
        }
    }

    return [output copy];
}

+ (NSArray *)hyp_acronyms
{
    return @[@"id", @"pdf", @"url", @"png", @"jpg"];
}

+ (NSArray *)hyp_dateAttributes
{
    return @[@"created_at", @"updated_at"];
}

@end

@implementation NSDate (ISO8601)

+ (NSDate *)hyp_dateFromISO8601String:(NSString *)iso8601
{
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

        if (len == 20 && str[len - 1] == 'Z') {        // UTC
            strncpy(newStr, str, len - 1);
            strncpy(newStr + len - 1, "+0000", 5);
        } else if (len == 24 && str[len - 1] == 'Z') { // Milliseconds parsing
            strncpy(newStr, str, len - 1);
            strncpy(newStr, str, len - 5);
            strncpy(newStr + len - 5, "+0000", 5);
        } else if (len == 25 && str[22] == ':') {      // Timezone
            strncpy(newStr, str, 22);
            strncpy(newStr + 22, str + 23, 2);
        } else {                                       // Poorly formatted timezone
            strncpy(newStr, str, len > 24 ? 24 : len);
        }

        // Add null terminator
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

@implementation NSManagedObject (HYPPropertyMapper)

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary
{
    for (__strong NSString *remoteKey in dictionary) {

        id value = [dictionary objectForKey:remoteKey];

        BOOL isReservedKey = ([[NSManagedObject hyp_reservedAttributes] containsObject:remoteKey]);
        if (isReservedKey) {
            remoteKey = [self hyp_prefixedAttribute:remoteKey];
        }

        id propertyDescription = [self hyp_propertyDescriptionForKey:remoteKey];
        if (!propertyDescription) continue;

        NSString *localKey = [propertyDescription name];

        if (value && ![value isKindOfClass:[NSNull class]]) {

            id procesedValue = [self hyp_valueForPropertyDescription:propertyDescription
                                                usingRemoteValue:value];


            if (![[self valueForKey:localKey] isEqual:procesedValue]) {
                [self setValue:procesedValue forKey:localKey];
            }

        } else {
            if ([self valueForKey:localKey]) {
                [self setValue:nil forKey:localKey];
            }
        }
    }
}

- (id)hyp_propertyDescriptionForKey:(NSString *)key
{
    for (id propertyDescription in [self.entity properties]) {

        if (![propertyDescription isKindOfClass:[NSAttributeDescription class]]) continue;

        if ([[propertyDescription name] isEqualToString:[key hyp_localString]]) {
            return propertyDescription;
        }
    }

    return nil;
}

- (id)hyp_valueForPropertyDescription:(id)propertyDescription usingRemoteValue:(id)value
{
    NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
    Class attributedClass = NSClassFromString([attributeDescription attributeValueClassName]);

    if ([value isKindOfClass:attributedClass]) return value;

    BOOL stringValueAndNumberAttribute = ([value isKindOfClass:[NSString class]] &&
                                          attributedClass == [NSNumber class]);

    BOOL numberValueAndStringAttribute = ([value isKindOfClass:[NSNumber class]] &&
                                          attributedClass == [NSString class]);

    BOOL stringValueAndDateAttribute   = ([value isKindOfClass:[NSString class]] &&
                                          attributedClass == [NSDate class]);

    if (stringValueAndNumberAttribute) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        return [formatter numberFromString:value];
    } else if (numberValueAndStringAttribute) {
        return [NSString stringWithFormat:@"%@", value];
    } else if (stringValueAndDateAttribute) {
        return [NSDate hyp_dateFromISO8601String:value];
    }

    return nil;
}

- (NSDictionary *)hyp_dictionary
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];

    for (id propertyDescription in [self.entity properties]) {

        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {

            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
            id value = [self valueForKey:[attributeDescription name]];
            NSMutableString *key = [[[propertyDescription name] hyp_remoteString] mutableCopy];

            BOOL nilOrNullValue = (!value || [value isKindOfClass:[NSNull class]]);
            if (nilOrNullValue) {
                mutableDictionary[key] = [NSNull null];
            } else {
                NSMutableString *key = [[[propertyDescription name] hyp_remoteString] mutableCopy];
                BOOL isReservedKey = ([[self hyp_reservedKeys] containsObject:key]);
                if (isReservedKey) {
                    [key replaceOccurrencesOfString:[self hyp_remotePrefix]
                                         withString:@""
                                            options:NSCaseInsensitiveSearch
                                              range:NSMakeRange(0, key.length)];
                }

                mutableDictionary[key] = value;
            }
        }
    }

    return [mutableDictionary copy];
}

- (NSString *)hyp_remotePrefix
{
    return [NSString stringWithFormat:@"%@_", [self.entity.name lowercaseString]];
}

- (NSString *)hyp_prefixedAttribute:(NSString *)attribute
{
    return [NSString stringWithFormat:@"%@%@", [self hyp_remotePrefix], attribute];
}

- (NSArray *)hyp_reservedKeys
{
    NSMutableArray *keys = [NSMutableArray array];
    NSArray *reservedAttributes = [NSManagedObject hyp_reservedAttributes];

    for (NSString *attribute in reservedAttributes) {
        [keys addObject:[self hyp_prefixedAttribute:attribute]];
    }

    return keys;
}

+ (NSArray *)hyp_reservedAttributes
{
    return @[@"id", @"type", @"description", @"signed"];
}

@end
