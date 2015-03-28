@import CoreData;

static NSString * const HYPPropertyMapperCustomRemoteKey = @"mapper.remote.key";

@interface NSManagedObject (HYPPropertyMapper)

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)hyp_dictionary;

@end
