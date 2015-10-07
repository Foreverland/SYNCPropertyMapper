#import "Recursive.h"

NS_ASSUME_NONNULL_BEGIN

@interface Recursive (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *remoteID;
@property (nullable, nonatomic, retain) Recursive *recursive;
@property (nullable, nonatomic, retain) NSSet<Recursive *> *recursives;

@end

@interface Recursive (CoreDataGeneratedAccessors)

- (void)addRecursivesObject:(Recursive *)value;
- (void)removeRecursivesObject:(Recursive *)value;
- (void)addRecursives:(NSSet<Recursive *> *)values;
- (void)removeRecursives:(NSSet<Recursive *> *)values;

@end

NS_ASSUME_NONNULL_END
