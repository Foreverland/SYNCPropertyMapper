//
//  NSManagedObject+HYPPropertyMapper.m
//
//  Created by Christoffer Winterkvist on 7/2/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "NSManagedObject+HYPPropertyMapper.h"

@implementation NSString (PrivateInflections)

#pragma mark - Private methods

- (NSString *)remoteString
{
    return [NSString lowerCaseFirstLetter:[NSString replacementIdentifier:@"_" inString:self]];
}

- (NSString *)localString
{
    return [NSString lowerCaseFirstLetter:[NSString replacementIdentifier:@"" inString:self]];
}

+ (NSString *)upperCaseFirstLetter:(NSString *)targetString
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:targetString];
    NSString *firstLetter = [[mutableString substringToIndex:1] uppercaseString];
    [mutableString replaceCharactersInRange:NSMakeRange(0,1)
                                 withString:firstLetter];
    return [mutableString copy];
}

+ (NSString *)lowerCaseFirstLetter:(NSString *)targetString
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:targetString];
    NSString *firstLetter = [[mutableString substringToIndex:1] lowercaseString];
    [mutableString replaceCharactersInRange:NSMakeRange(0,1)
                                 withString:firstLetter];

    return [mutableString copy];
}

+ (NSString *)replacementIdentifier:(NSString *)replacementString inString:(NSString *)targetString
{
    NSScanner *scanner = [NSScanner scannerWithString:targetString];
    scanner.caseSensitive = YES;

    NSCharacterSet *identifierSet = [NSCharacterSet characterSetWithCharactersInString:@"_- "];

    NSCharacterSet *alphanumericSet = [NSCharacterSet alphanumericCharacterSet];
    NSCharacterSet *uppercaseSet = [NSCharacterSet uppercaseLetterCharacterSet];
    NSCharacterSet *lowercaseSet = [NSCharacterSet lowercaseLetterCharacterSet];

    NSString *buffer = nil;
    NSMutableString *output = [NSMutableString string];

    while (!scanner.isAtEnd) {
        if ([scanner scanCharactersFromSet:identifierSet intoString:&buffer]) {
            continue;
        }

        if ([replacementString length]) {
            if ([scanner scanCharactersFromSet:uppercaseSet intoString:&buffer]) {
                [output appendString:replacementString];
                [output appendString:[buffer lowercaseString]];
            }
            if ([scanner scanCharactersFromSet:lowercaseSet intoString:&buffer]) {
                [output appendString:[buffer lowercaseString]];
            }
        } else {
            if ([scanner scanCharactersFromSet:alphanumericSet intoString:&buffer]) {
                [output appendString:[buffer capitalizedString]];
            }
        }
    }

    return [output copy];
}

@end

@implementation NSDate (ISO8601)

+ (NSDate *)__dateFromISO8601String:(NSString *)iso8601
{
    // Return nil if nil is given
    if (!iso8601 || [iso8601 isEqual:[NSNull null]]) {
        return nil;
    }

    // Parse number
    if ([iso8601 isKindOfClass:[NSNumber class]]) {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)iso8601 doubleValue]];
    }

    // Parse string
    else if ([iso8601 isKindOfClass:[NSString class]]) {
        if (!iso8601) {
            return nil;
        }

        const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
        char newStr[25];

        struct tm tm;
        size_t len = strlen(str);
        if (len == 0) {
            return nil;
        }

        // UTC
        if (len == 20 && str[len - 1] == 'Z') {
            strncpy(newStr, str, len - 1);
            strncpy(newStr + len - 1, "+0000", 5);
        }

        //Milliseconds parsing
        else if (len == 24 && str[len - 1] == 'Z') {
            strncpy(newStr, str, len - 1);
            strncpy(newStr, str, len - 5);
            strncpy(newStr + len - 5, "+0000", 5);
        }

        // Timezone
        else if (len == 25 && str[22] == ':') {
            strncpy(newStr, str, 22);
            strncpy(newStr + 22, str + 23, 2);
        }

        // Poorly formatted timezone
        else {
            strncpy(newStr, str, len > 24 ? 24 : len);
        }

        // Add null terminator
        newStr[sizeof(newStr) - 1] = 0;

        if (strptime(newStr, "%FT%T%z", &tm) == NULL) {
            return nil;
        }

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
    for (NSString *remoteKey in dictionary) {

        id value = [dictionary objectForKey:remoteKey];
        id propertyDescription = [self propertyDescriptionForKey:remoteKey];
        if (!propertyDescription) continue;

        NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
        Class attributedClass = NSClassFromString([attributeDescription attributeValueClassName]);

        NSString *localKey = [propertyDescription name];

        if (value && ![value isKindOfClass:[NSNull class]]) {

            if ([value isKindOfClass:attributedClass]) {
                if (![[self valueForKey:localKey] isEqual:value]) {
                    [self setValue:value forKey:localKey];
                }
            } else {
                [self processValue:value withDifferentPropertyDescription:propertyDescription];
            }

        } else {
            [self setValue:nil forKey:localKey];
        }
    }
}

- (id)propertyDescriptionForKey:(NSString *)key
{
    for (id propertyDescription in [self.entity properties]) {

        if (![propertyDescription isKindOfClass:[NSAttributeDescription class]]) continue;

        if ([[propertyDescription name] isEqualToString:[key localString]]) {
            return propertyDescription;
        }
    }

    return nil;
}

- (void)processValue:(id)value withDifferentPropertyDescription:(id)propertyDescription
{
    NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
    Class attributedClass = NSClassFromString([attributeDescription attributeValueClassName]);

    BOOL stringValueAndNumberAttribute = ([value isKindOfClass:[NSString class]] &&
                                          attributedClass == [NSNumber class]);

    BOOL numberValueAndStringAttribute = ([value isKindOfClass:[NSNumber class]] &&
                                          attributedClass == [NSString class]);

    BOOL stringValueAndDateAttribute = ([value isKindOfClass:[NSString class]] &&
                                        attributedClass == [NSDate class]);

    id transformedValue = nil;

    if (stringValueAndNumberAttribute) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        transformedValue = [formatter numberFromString:value];
    } else if (numberValueAndStringAttribute) {
        transformedValue = [NSString stringWithFormat:@"%@", value];
    } else if (stringValueAndDateAttribute) {
        transformedValue = [NSDate __dateFromISO8601String:value];
    }

    if (transformedValue) {
        [self setValue:transformedValue forKey:[propertyDescription name]];
    }
}

- (NSDictionary *)hyp_dictionary
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];

    for (id propertyDescription in [self.entity properties]) {

        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
            NSString *key = [[propertyDescription name] remoteString];

            id value = [self valueForKey:[attributeDescription name]];

            if (!value || [value isKindOfClass:[NSNull class]]) {
                continue;
            }

            mutableDictionary[key] = value;
        }
    }

    return [mutableDictionary copy];
}

@end
