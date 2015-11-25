#import "Apartment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Apartment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) NSSet<Room *> *rooms;
@property (nullable, nonatomic, retain) Building *building;

@end

@interface Apartment (CoreDataGeneratedAccessors)

- (void)addRoomsObject:(Room *)value;
- (void)removeRoomsObject:(Room *)value;
- (void)addRooms:(NSSet<Room *> *)values;
- (void)removeRooms:(NSSet<Room *> *)values;

@end

NS_ASSUME_NONNULL_END
