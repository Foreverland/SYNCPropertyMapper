#import "NSManagedObject+HYPPropertyMapper.h"

#import "NSString+HYPNetworking.h"

static NSString * const HYPPropertyMapperCustomRemoteKey = @"mapper.remote.key";
static NSString * const HYPPropertyMapperCustomRemoteIsPrimaryKey = @"mapper.remote.is_primary_key";
static NSString * const HYPPropertyMapperCustomLocalIsPrimaryKey = @"mapper.local.is_primary_key";

static NSString * const HYPPropertyMapperDefaultRemoteKey = @"id";
static NSString * const HYPPropertyMapperDefaultLocalKey = @"remote_id";

static NSString * const HYPPropertyMapperKeyValue = @"value";
static NSString * const HYPPropertyMapperNestedAttributesKey = @"attributes";
static NSString * const HYPPropertyMapperDestroyKey = @"destroy";

@implementation NSDate (ISO8601)

+ (NSDate *)__dateFromISO8601String:(NSString *)iso8601
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

#pragma mark - Public methods

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary
{
    for (__strong NSString *key in dictionary) {

        id value = [dictionary objectForKey:key];

        BOOL isReservedKey = ([[NSManagedObject reservedAttributes] containsObject:key]);
        if (isReservedKey) {
            key = [self prefixedAttribute:key];
        }

        id propertyDescription = [self propertyDescriptionForKey:key];

        for (NSString *dictionaryKey in self.entity.propertiesByName) {
            NSDictionary *userInfo = [self.entity.propertiesByName[dictionaryKey] userInfo];
            NSString *remoteKeyValue = userInfo[HYPPropertyMapperCustomRemoteKey];
            BOOL hasCustomKeyMapper = (remoteKeyValue &&
                                       ![remoteKeyValue isEqualToString:HYPPropertyMapperKeyValue] &&
                                       [remoteKeyValue isEqualToString:key]);
            if (hasCustomKeyMapper) {
                propertyDescription = self.entity.propertiesByName[dictionaryKey];
                break;
            }
        }

        if (!propertyDescription) {
            continue;
        }

        NSString *localKey = [propertyDescription name];

        BOOL valueExists = (value && ![value isKindOfClass:[NSNull class]]);
        if (valueExists) {
            id processedValue = [self valueForPropertyDescription:propertyDescription
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

- (NSDictionary *)hyp_dictionary
{
    NSMutableDictionary *managedObjectAttributes = [NSMutableDictionary new];

    for (id propertyDescription in [self.entity properties]) {
        if ([propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
            NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;

            id value = [self valueForKey:[attributeDescription name]];
            BOOL nilOrNullValue = (!value ||
                                   [value isKindOfClass:[NSNull class]]);
            if (nilOrNullValue) {
                value = [NSNull null];
            }

            NSDictionary *userInfo = [propertyDescription userInfo];
            NSString *key;

            BOOL hasCustomMapping = (userInfo[HYPPropertyMapperCustomRemoteKey] &&
                                     ![userInfo[HYPPropertyMapperCustomRemoteKey] isEqualToString:HYPPropertyMapperKeyValue]);
            if (hasCustomMapping) {
                key = userInfo[HYPPropertyMapperCustomRemoteKey];
            } else {
                key = [[propertyDescription name] hyp_remoteString];
            }

            BOOL isReservedKey = ([[self reservedKeys] containsObject:key]);
            if (isReservedKey) {
                if ([key isEqualToString:HYPPropertyMapperDefaultLocalKey]) {
                    key = HYPPropertyMapperDefaultRemoteKey;
                } else {
                    NSMutableString *prefixedKey = [key mutableCopy];
                    [prefixedKey replaceOccurrencesOfString:[self remotePrefix]
                                                 withString:@""
                                                    options:NSCaseInsensitiveSearch
                                                      range:NSMakeRange(0, prefixedKey.length)];
                    key = [prefixedKey copy];
                }
            }

            managedObjectAttributes[key] = value;

        } else if ([propertyDescription isKindOfClass:[NSRelationshipDescription class]]) {
            NSString *relationshipName = [propertyDescription name];

            id relationships = [self valueForKey:relationshipName];
            BOOL isToOneRelationship = (![relationships isKindOfClass:[NSSet class]]);
            if (isToOneRelationship) {
                continue;
            }

            NSMutableDictionary *relations = [NSMutableDictionary new];

            NSUInteger relationIndex = 0;

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
                        NSString *localKey = [HYPPropertyMapperDefaultLocalKey hyp_localString];
                        BOOL attributeIsKey = ([localKey isEqualToString:attribute]);

                        NSString *key;
                        if (attributeIsKey) {
                            key = HYPPropertyMapperDefaultRemoteKey;
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

- (id)propertyDescriptionForKey:(NSString *)key
{
    id foundPropertyDescription;

    for (id propertyDescription in [self.entity properties]) {
        if (![propertyDescription isKindOfClass:[NSAttributeDescription class]]) {
            continue;
        }

        if ([[propertyDescription name] isEqualToString:[key hyp_localString]]) {
            foundPropertyDescription = propertyDescription;
        }
    }

    return foundPropertyDescription;
}

- (id)valueForPropertyDescription:(id)propertyDescription usingRemoteValue:(id)removeValue
{
    id value;

    NSAttributeDescription *attributeDescription = (NSAttributeDescription *)propertyDescription;
    Class attributedClass = NSClassFromString([attributeDescription attributeValueClassName]);

    if ([removeValue isKindOfClass:attributedClass]) {
        value = removeValue;
    }

    BOOL stringValueAndNumberAttribute = ([removeValue isKindOfClass:[NSString class]] &&
                                          attributedClass == [NSNumber class]);

    BOOL numberValueAndStringAttribute = ([removeValue isKindOfClass:[NSNumber class]] &&
                                          attributedClass == [NSString class]);

    BOOL stringValueAndDateAttribute   = ([removeValue isKindOfClass:[NSString class]] &&
                                          attributedClass == [NSDate class]);

    BOOL arrayOrDictionaryValueAndDataAttribute   = (([removeValue isKindOfClass:[NSArray class]] ||
                                                      [removeValue isKindOfClass:[NSDictionary class]]) &&
                                                     attributedClass == [NSData class]);

    if (stringValueAndNumberAttribute) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        value = [formatter numberFromString:removeValue];
    } else if (numberValueAndStringAttribute) {
        value = [NSString stringWithFormat:@"%@", removeValue];
    } else if (stringValueAndDateAttribute) {
        value = [NSDate __dateFromISO8601String:removeValue];
    } else if (arrayOrDictionaryValueAndDataAttribute) {
        value = [NSKeyedArchiver archivedDataWithRootObject:removeValue];
    }

    return value;
}

- (NSString *)remotePrefix
{
    return [NSString stringWithFormat:@"%@_", [self.entity.name lowercaseString]];
}

- (NSString *)prefixedAttribute:(NSString *)attribute
{
    NSString *prefixedAttribute;

    if ([attribute isEqualToString:HYPPropertyMapperDefaultRemoteKey]) {
        prefixedAttribute = HYPPropertyMapperDefaultLocalKey;
    } else {
        prefixedAttribute = [NSString stringWithFormat:@"%@%@", [self remotePrefix], attribute];
    }

    return prefixedAttribute;
}

- (NSArray *)reservedKeys
{
    NSMutableArray *keys = [NSMutableArray new];
    NSArray *reservedAttributes = [NSManagedObject reservedAttributes];

    for (NSString *attribute in reservedAttributes) {
        [keys addObject:[self prefixedAttribute:attribute]];
    }

    [keys addObject:HYPPropertyMapperDefaultLocalKey];

    return keys;
}

+ (NSArray *)reservedAttributes
{
    return @[@"id", @"type", @"description", @"signed"];
}

@end
