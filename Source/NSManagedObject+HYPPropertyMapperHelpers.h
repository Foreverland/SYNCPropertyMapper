@import CoreData;

static NSString * const HYPPropertyMapperDefaultRemoteValue = @"id";
static NSString * const HYPPropertyMapperDefaultLocalValue = @"remoteID";

@interface NSManagedObject (HYPPropertyMapperHelpers)

- (NSAttributeDescription *)attributeDescriptionForRemoteKey:(NSString *)key;

- (id)valueForAttributeDescription:(id)attributeDescription
                  usingRemoteValue:(id)removeValue;

- (NSString *)remoteKeyForAttributeDescription:(NSAttributeDescription *)attributeDescription;

+ (NSArray *)reservedAttributes;

- (NSString *)prefixedAttribute:(NSString *)attribute;

@end
