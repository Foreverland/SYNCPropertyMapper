@import CoreData;
@import XCTest;

#import "NSManagedObject+HYPPropertyMapper.h"

#import "User.h"
#import "Note.h"
#import "Company.h"
#import "Market.h"
#import "DATAStack.h"

@interface NSManagedObject (PrivateMethods)

- (NSAttributeDescription *)attributeDescriptionForRemoteKey(NSString *)key;

- (id)valueForAttributeDescription:(id)attributeDescription
                  usingRemoteValue:(id)removeValue;

@end

@interface PrivateTests : XCTestCase

@end

@implementation PrivateTests

- (id)entityNamed:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:self.managedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext {
    DATAStack *dataStack = [[DATAStack alloc] initWithModelName:@"Model"
                                                         bundle:[NSBundle bundleForClass:[self class]]
                                                      storeType:DATAStackInMemoryStoreType];
    return dataStack.mainContext;
}

- (void)testAttributeDescriptionForKey {
    Market *market = [self entityNamed:@"Market"];
    [market attributeDescriptionForRemoteKey@"uniqueId"];
    [market attributeDescriptionForRemoteKey@"otherAttribute"];
}

- (void)testValueForAttributeDescription {

}

@end
