@import CoreData;

#import "NSManagedObject+HYPPropertyMapper.h"

static NSString * const HYPPropertyMapperDestroyKey = @"destroy";
static NSString * const HYPPropertyMapperCustomValueTransformerKey = @"hyper.valueTransformer";

@interface NSManagedObject (HYPPropertyMapperHelpers)

- (id)valueForAttributeDescription:(NSAttributeDescription *)attributeDescription
                     dateFormatter:(NSDateFormatter *)dateFormatter
                  relationshipType:(HYPPropertyMapperRelationshipType)relationshipType;

- (NSAttributeDescription *)attributeDescriptionForRemoteKey:(NSString *)key;
- (NSArray *)attributeDescriptionsForRemoteKeyPath:(NSString *)key;

- (id)valueForAttributeDescription:(id)attributeDescription
                  usingRemoteValue:(id)removeValue;

- (NSString *)remoteKeyForAttributeDescription:(NSAttributeDescription *)attributeDescription;

- (NSString *)remoteKeyForAttributeDescription:(NSAttributeDescription *)attributeDescription usingRelationshipType:(HYPPropertyMapperRelationshipType)relationshipType;

+ (NSArray *)reservedAttributes;

- (NSString *)prefixedAttribute:(NSString *)attribute;

@end
