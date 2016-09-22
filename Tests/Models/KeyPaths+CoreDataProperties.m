#import "KeyPaths+CoreDataProperties.h"

@implementation KeyPaths (CoreDataProperties)

+ (NSFetchRequest<KeyPaths *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"KeyPaths"];
}

@dynamic snakeCaseDepthOne;
@dynamic snakeCaseDepthTwo;

@end
