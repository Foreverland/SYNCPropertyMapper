#import "NSManagedObject+HYPPropertyMapper.h"

#import "NSString+HYPNetworking.h"

static NSString * const HYPPropertyMapperDefaultRemoteValue = @"id";
static NSString * const HYPPropertyMapperDefaultLocalValue = @"remoteID";

static NSString * const HYPPropertyMapperNestedAttributesKey = @"attributes";
static NSString * const HYPPropertyMapperDestroyKey = @"destroy";

static NSString * const HYPPropertyMapperDateNoTimestampFormat = @"YYYY-MM-DD";
static NSString * const HYPPropertyMapperTimestamp = @"T00:00:00+00:00";

@interface NSDate (HYPISO8601)

+ (NSDate *)hyp_dateFromISO8601String:(NSString *)iso8601;

@end

@implementation NSManagedObject (HYPPropertyMapper)

#pragma mark - Public methods

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary {
    for (__strong NSString *key in dictionary) {

        id value = [dictionary objectForKey:key];

        BOOL isReservedKey = ([[NSManagedObject reservedAttributes] containsObject:key]);
        if (isReservedKey) {
            key = [self prefixedAttribute:key];
        }

        NSAttributeDescription *attributeDescription = [self attributeDescriptionForRemoteKey:key];
        if (attributeDescription) {
            NSString *localKey = attributeDescription.name;

            BOOL valueExists = (value &&
                                ![value isKindOfClass:[NSNull class]]);
            if (valueExists) {
                id processedValue = [self valueForAttributeDescription:attributeDescription
                                                      usingRemoteValue:value];

                BOOL valueHasChanged = (![[self valueForKey:localKey] isEqual:processedValue]);
                if (valueHasChanged) {
                    [self setValue:processedValue forKey:localKey];
                }
            } else if ([self valueForKey:localKey]) {
                [self setValue:nil forKey:localKey];
            }
        }
    }
}

- (NSDictionary *)hyp_dictionary {
    NSMutableDictionary *managedObjectAttributes = [NSMutableDictionary new];

    for (id propertyDescription in self.entity.properties) {
        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;

            id value = [self valueForKey:attributeDescription.name];
            BOOL nilOrNullValue = (!value ||
                                   [value isKindOfClass:[NSNull class]]);
            if (nilOrNullValue) {
                value = [NSNull null];
            }

            NSString *remoteKey = [self remoteKeyForAttributeDescription:attributeDescription];
            managedObjectAttributes[remoteKey] = value;

        } else if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
            NSString *relationshipName = [propertyDescription name];

            id relationships = [self valueForKey:relationshipName];
            BOOL isToOneRelationship = (![relationships isKindOfClass:[NSSet class]]);
            if (isToOneRelationship) {
                continue;
            }

            NSUInteger relationIndex = 0;
            NSMutableDictionary *relations = [NSMutableDictionary new];
            for (NSManagedObject *relation in relationships) {
                BOOL hasValues = NO;

                for (NSAttributeDescription *propertyDescription in [relation.entity properties]) {
                    if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
                        NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
                        id value = [relation valueForKey:[attributeDescription name]];
                        if (value) {
                            hasValues = YES;
                        } else {
                            continue;
                        }

                        NSString *attribute = [propertyDescription name];
                        NSString *localKey = HYPPropertyMapperDefaultLocalValue;
                        BOOL attributeIsKey = ([localKey isEqualToString:attribute]);

                        NSString *key;
                        if (attributeIsKey) {
                            key = HYPPropertyMapperDefaultRemoteValue;
                        } else if ([attribute isEqualToString:HYPPropertyMapperDestroyKey]) {
                            key = [NSString stringWithFormat:@"_%@", HYPPropertyMapperDestroyKey];
                        } else {
                            key = [attribute hyp_remoteString];
                        }

                        if (value) {
                            NSString *relationIndexString = [NSString stringWithFormat:@"%lu", (unsigned long)relationIndex];
                            NSMutableDictionary *dictionary = [relations[relationIndexString] mutableCopy] ?: [NSMutableDictionary new];
                            dictionary[key] = value;
                            relations[relationIndexString] = dictionary;
                        }
                    }
                }

                if (hasValues) {
                    relationIndex++;
                }
            }

            NSString *nestedAttributesPrefix = [NSString stringWithFormat:@"%@_%@", [relationshipName hyp_remoteString], HYPPropertyMapperNestedAttributesKey];
            [managedObjectAttributes setValue:relations forKey:nestedAttributesPrefix];
        }
    }

    return [managedObjectAttributes copy];
}

#pragma mark - Private methods

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
        if ([remoteValue length] == [HYPPropertyMapperDateNoTimestampFormat length]) {
            NSMutableString *mutableRemoteValue = [remoteValue mutableCopy];
            [mutableRemoteValue appendString:HYPPropertyMapperTimestamp];
            remoteValue = [mutableRemoteValue copy];
        }

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

@implementation NSDate (HYPISO8601)

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
