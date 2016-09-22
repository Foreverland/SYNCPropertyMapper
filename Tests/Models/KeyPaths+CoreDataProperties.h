#import "KeyPaths+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface KeyPaths (CoreDataProperties)

+ (NSFetchRequest<KeyPaths *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *snakeCaseDepthOne;
@property (nullable, nonatomic, copy) NSString *snakeCaseDepthTwo;

@end

NS_ASSUME_NONNULL_END
