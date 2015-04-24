@import CoreData;

static NSString * const HYPPropertyMapperCustomRemoteKey = @"hyper.remoteKey";

@interface NSManagedObject (HYPPropertyMapper)

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary;

- (NSDictionary *)hyp_dictionary;

@end
