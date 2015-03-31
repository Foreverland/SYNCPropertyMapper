@import CoreData;

static NSString * const HYPPropertyMapperCustomRemoteKey = @"mapper.remote.key";
static NSString * const HYPPropertyMapperCustomRelationshipKey = @"mapper.remote.key_relationship";

@interface NSManagedObject (HYPPropertyMapper)

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)hyp_dictionary;

@end
