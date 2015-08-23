#import "NSManagedObject+HYPPropertyMapperHelpers.h"

#import "NSManagedObject+HYPPropertyMapper.h"
#import "NSString+HYPNetworking.h"
#import "NSDate+HYPPropertyMapper.h"

@implementation NSManagedObject (HYPPropertyMapperHelpers)

- (NSAttributeDescription *)attributeDescriptionForRemoteKey:(NSString *)remoteKey {
    __block NSAttributeDescription *foundAttributeDescription;

    [self.entity.properties enumerateObjectsUsingBlock:^(id propertyDescription, NSUInteger idx, BOOL *stop) {
        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;

            NSDictionary *userInfo = [self.entity.propertiesByName[attributeDescription.name] userInfo];
            NSString *customRemoteKey = userInfo[HYPPropertyMapperCustomRemoteKey];
            if (customRemoteKey.length > 0 && [customRemoteKey isEqualToString:remoteKey]) {
                foundAttributeDescription = self.entity.propertiesByName[attributeDescription.name];
            } else if ([attributeDescription.name isEqualToString:[remoteKey hyp_localString]]) {
                foundAttributeDescription = attributeDescription;
            }

            if (foundAttributeDescription) {
                *stop = YES;
            }
        }
    }];

    if (!foundAttributeDescription) {
        [self.entity.properties enumerateObjectsUsingBlock:^(id propertyDescription, NSUInteger idx, BOOL *stop) {
            if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;

                if ([remoteKey isEqualToString:HYPPropertyMapperDefaultRemoteValue] &&
                    [attributeDescription.name isEqualToString:HYPPropertyMapperDefaultLocalValue]) {
                    foundAttributeDescription = self.entity.propertiesByName[attributeDescription.name];
                }

                if (foundAttributeDescription) {
                    *stop = YES;
                }
            }
        }];
    }

    return foundAttributeDescription;
}

- (NSString *)remoteKeyForAttributeDescription:(NSAttributeDescription *)attributeDescription {
    NSDictionary *userInfo = attributeDescription.userInfo;
    NSString *localKey = attributeDescription.name;
    NSString *remoteKey;

    NSString *customRemoteKey = userInfo[HYPPropertyMapperCustomRemoteKey];
    if (customRemoteKey) {
        remoteKey = customRemoteKey;
    } else if ([localKey isEqualToString:HYPPropertyMapperDefaultLocalValue]) {
        remoteKey = HYPPropertyMapperDefaultRemoteValue;
    } else {
        remoteKey = [localKey hyp_remoteString];
    }

    BOOL isReservedKey = ([[self reservedKeys] containsObject:remoteKey]);
    if (isReservedKey) {
        NSMutableString *prefixedKey = [remoteKey mutableCopy];
        [prefixedKey replaceOccurrencesOfString:[self remotePrefix]
                                     withString:@""
                                        options:NSCaseInsensitiveSearch
                                          range:NSMakeRange(0, prefixedKey.length)];
        remoteKey = [prefixedKey copy];
    }

    return remoteKey;
}

- (id)valueForAttributeDescription:(NSAttributeDescription *)attributeDescription
                  usingRemoteValue:(id)remoteValue {
    id value;

    Class attributedClass = NSClassFromString([attributeDescription attributeValueClassName]);

    if ([remoteValue isKindOfClass:attributedClass]) {
        value = remoteValue;
    }

    BOOL stringValueAndNumberAttribute = ([remoteValue isKindOfClass:[NSString class]] &&
                                          attributedClass == [NSNumber class]);

    BOOL numberValueAndStringAttribute = ([remoteValue isKindOfClass:[NSNumber class]] &&
                                          attributedClass == [NSString class]);

    BOOL stringValueAndDateAttribute   = ([remoteValue isKindOfClass:[NSString class]] &&
                                          attributedClass == [NSDate class]);

    BOOL arrayOrDictionaryValueAndDataAttribute   = (([remoteValue isKindOfClass:[NSArray class]] ||
                                                      [remoteValue isKindOfClass:[NSDictionary class]]) &&
                                                     attributedClass == [NSData class]);

    if (stringValueAndNumberAttribute) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        value = [formatter numberFromString:remoteValue];
    } else if (numberValueAndStringAttribute) {
        value = [NSString stringWithFormat:@"%@", remoteValue];
    } else if (stringValueAndDateAttribute) {
        value = [NSDate hyp_dateFromISO8601String:remoteValue];
    } else if (arrayOrDictionaryValueAndDataAttribute) {
        value = [NSKeyedArchiver archivedDataWithRootObject:remoteValue];
    }

    return value;
}

- (NSString *)remotePrefix {
    return [NSString stringWithFormat:@"%@_", [self.entity.name lowercaseString]];
}

- (NSString *)prefixedAttribute:(NSString *)attribute {
    return [NSString stringWithFormat:@"%@%@", [self remotePrefix], attribute];
}

- (NSArray *)reservedKeys {
    NSMutableArray *keys = [NSMutableArray new];
    NSArray *reservedAttributes = [NSManagedObject reservedAttributes];

    for (NSString *attribute in reservedAttributes) {
        [keys addObject:[self prefixedAttribute:attribute]];
    }

    return keys;
}

+ (NSArray *)reservedAttributes {
    return @[@"type", @"description", @"signed"];
}

@end
