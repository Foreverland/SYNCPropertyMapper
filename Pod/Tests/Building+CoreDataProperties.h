#import "Building.h"

NS_ASSUME_NONNULL_BEGIN

@interface Building (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *apartments;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *parks;

@end

@interface Building (CoreDataGeneratedAccessors)

- (void)addApartmentsObject:(NSManagedObject *)value;
- (void)removeApartmentsObject:(NSManagedObject *)value;
- (void)addApartments:(NSSet<NSManagedObject *> *)values;
- (void)removeApartments:(NSSet<NSManagedObject *> *)values;

- (void)addParksObject:(NSManagedObject *)value;
- (void)removeParksObject:(NSManagedObject *)value;
- (void)addParks:(NSSet<NSManagedObject *> *)values;
- (void)removeParks:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
