//
//  NSManagedObject+HYPPropertyMapper.m
//
//  Created by Christoffer Winterkvist on 7/2/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "NSManagedObject+HYPPropertyMapper.h"

@implementation NSManagedObject (HYPPropertyMapper)

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary
{
    for (id propertyDescription in [self.entity properties]) {
        NSString *key = [self convertToRemoteString:[propertyDescription name]];

        id value = dictionary[key];

        if (![propertyDescription isKindOfClass:[NSAttributeDescription class]]) return;

        NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
        Class attributedClass = NSClassFromString([attributeDescription attributeValueClassName]);

        if (value && ![value isKindOfClass:[NSNull class]]) {

            if ([value isKindOfClass:[NSString class]] && attributedClass == [NSNumber class]) {
                NSNumberFormatter *formatter = [NSNumberFormatter new];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *number = [formatter numberFromString:value];
                [self setValue:number forKey:[propertyDescription name]];
            } else {

                if ([value isKindOfClass:[NSNumber class]] && attributedClass == [NSString class]) {
                    [self setValue:[NSString stringWithFormat:@"%@", value] forKey:[propertyDescription name]];
                } else {
                    [self setValue:value forKey:[propertyDescription name]];
                }
            }
        } else {

            if (![value isKindOfClass:attributedClass]) {

                if ([value isKindOfClass:[NSString class]] && attributedClass == [NSNumber class]) {
                    NSNumberFormatter *formatter = [NSNumberFormatter new];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    [self setValue:[formatter numberFromString:value] forKey:key];
                }
            } else {

                if ([value isKindOfClass:[NSNumber class]] && attributedClass == [NSString class]) {
                    [self setValue:[NSString stringWithFormat:@"%@", value] forKey:[propertyDescription name]];
                } else {
                    [self setValue:value forKey:[propertyDescription name]];
                }
            }
        }
    }
}

- (NSDictionary *)hyp_dictionary
{
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionary];

    for (id propertyDescription in [self.entity properties]) {

        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
            NSString *key = [self convertToRemoteString:[propertyDescription name]];

            id value = [self valueForKey:[attributeDescription name]];

            if (!value || [value isKindOfClass:[NSNull class]]) {
                value = [NSNull null];
            }

            mutableDictionary[key] = value;
        }
    }

    return [mutableDictionary copy];
}

#pragma mark - Private methods

- (NSString *)convertToRemoteString:(NSString *)string
{
    return [self replacementIdentifier:@"_" inString:[self lowerCaseFirstLetter:string]];
}

- (NSString *)convertToLocalString:(NSString *)string
{
    return [self replacementIdentifier:@"" inString:[self lowerCaseFirstLetter:string]];
}

- (NSString *)upperCaseFirstLetter:(NSString *)targetString
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:targetString];
    NSString *firstLetter = [[mutableString substringToIndex:1] uppercaseString];
    [mutableString replaceCharactersInRange:NSMakeRange(0,1)
                                 withString:firstLetter];
    return [mutableString copy];
}

- (NSString *)lowerCaseFirstLetter:(NSString *)targetString
{
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:targetString];
    NSString *firstLetter = [[mutableString substringToIndex:1] lowercaseString];
    [mutableString replaceCharactersInRange:NSMakeRange(0,1)
                                 withString:firstLetter];
    return [mutableString copy];
}

- (NSString *)replacementIdentifier:(NSString *)replacementString inString:(NSString *)targetString
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
