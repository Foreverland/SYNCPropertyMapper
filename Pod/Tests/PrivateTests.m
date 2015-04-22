@import CoreData;
@import XCTest;

#import "NSManagedObject+HYPPropertyMapper.h"

@interface NSManagedObject (PrivateMethods)

- (NSAttributeDescription *)attributeDescriptionForKey:(NSString *)key;

- (id)valueForAttributeDescription:(id)attributeDescription
                  usingRemoteValue:(id)removeValue;

@end

@interface PrivateTests : XCTestCase

@end

@implementation PrivateTests

@end
