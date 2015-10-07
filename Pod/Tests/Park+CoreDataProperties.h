#import "Park.h"

NS_ASSUME_NONNULL_BEGIN

@interface Park (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) Building *building;

@end

NS_ASSUME_NONNULL_END
