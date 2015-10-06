@import CoreData;

#import "NSManagedObject+HYPPropertyMapper.h"

static NSString * const HYPPropertyMapperDefaultRemoteValue = @"id";
static NSString * const HYPPropertyMapperDefaultLocalValue = @"remoteID";
static NSString * const HYPPropertyMapperDestroyKey = @"destroy";

@interface NSManagedObject (HYPPropertyMapperHelpers)

- (id)valueForAttributeDescription:(NSAttributeDescription *)attributeDescription
                     dateFormatter:(NSDateFormatter *)dateFormatter
                  relationshipType:(HYPPropertyMapperRelationshipType)relationshipType;

- (NSAttributeDescription *)attributeDescriptionForRemoteKey:(NSString *)key;

- (id)valueForAttributeDescription:(id)attributeDescription
                  usingRemoteValue:(id)removeValue;

- (NSString *)remoteKeyForAttributeDescription:(NSAttributeDescription *)attributeDescription;

- (NSString *)remoteKeyForAttributeDescription:(NSAttributeDescription *)attributeDescription usingRelationshipType:(HYPPropertyMapperRelationshipType)relationshipType;

+ (NSArray *)reservedAttributes;

- (NSString *)prefixedAttribute:(NSString *)attribute;

@end
