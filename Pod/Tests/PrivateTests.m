@import CoreData;
@import XCTest;

#import "NSManagedObject+HYPPropertyMapper.h"

#import "User.h"
#import "Note.h"
#import "Company.h"
#import "Market.h"
#import "DATAStack.h"

@interface NSManagedObject (PrivateMethods)

- (NSAttributeDescription *)attributeDescriptionForRemoteKey:(NSString *)key;

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
    NSAttributeDescription *attributeDescription;

    Company *company = [self entityNamed:@"Company"];

    attributeDescription = [company attributeDescriptionForRemoteKey:@"name"];
    XCTAssertEqualObjects(attributeDescription.name, @"name");

    attributeDescription = [company attributeDescriptionForRemoteKey:@"id"];
    XCTAssertEqualObjects(attributeDescription.name, @"remoteID");

    Market *market = [self entityNamed:@"Market"];

    attributeDescription = [market attributeDescriptionForRemoteKey:@"id"];
    XCTAssertEqualObjects(attributeDescription.name, @"uniqueId");

    attributeDescription = [market attributeDescriptionForRemoteKey:@"other_attribute"];
    XCTAssertEqualObjects(attributeDescription.name, @"otherAttribute");

    User *user = [self entityNamed:@"User"];

    attributeDescription = [user attributeDescriptionForRemoteKey:@"age_of_person"];
    XCTAssertEqualObjects(attributeDescription.name, @"age");

    attributeDescription = [user attributeDescriptionForRemoteKey:@"driver_identifier_str"];
    XCTAssertEqualObjects(attributeDescription.name, @"driverIdentifier");

    attributeDescription = [user attributeDescriptionForRemoteKey:@"not_found_key"];
    XCTAssertNil(attributeDescription);
}

- (void)testValueForAttributeDescription {

}

@end
