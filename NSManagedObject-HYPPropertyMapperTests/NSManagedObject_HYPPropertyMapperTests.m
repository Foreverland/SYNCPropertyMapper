//
//  NSManagedObject_HYPPropertyMapperTests.m
//  NSManagedObject-HYPPropertyMapperTests
//
//  Created by Christoffer Winterkvist on 14/09/14.
//
//

#import <CoreData/CoreData.h>
#import <XCTest/XCTest.h>
#import "NSManagedObject+HYPPropertyMapper.h"

@interface NSManagedObject_HYPPropertyMapperTests : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObject *testUser;

@end

@implementation NSManagedObject_HYPPropertyMapperTests

#pragma mark - Set up

+ (NSManagedObjectContext *)managedObjectContextForTests
{
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSInMemoryStoreType
                                                 configuration:nil
                                                           URL:nil
                                                       options:nil
                                                         error:nil];
    NSAssert(store, @"Should have a store by now");

    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;

    return moc;
}

- (void)setUp
{
    [super setUp];
    self.managedObjectContext = [NSManagedObject_HYPPropertyMapperTests managedObjectContextForTests];

    self.testUser = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                                  inManagedObjectContext:self.managedObjectContext];

    [self.testUser setValue:@"John" forKey:@"firstName"];
    [self.testUser setValue:@"Hyperseed" forKey:@"lastName"];
}

- (void)tearDown
{
    [self.managedObjectContext rollback];
    [super tearDown];
}

#pragma mark - Inflections

- (void)testReplacementIdentifier
{
    NSString *testString = @"first_name";

    XCTAssert([[testString replacementIdentifier:@""] isEqualToString:@"FirstName"],
              @"[[%@ replacementIdentifier:@""] isEqualToString:%@]",
              [testString replacementIdentifier:@""], @"FirstName");

    testString = @"id";

    XCTAssert([[testString replacementIdentifier:@""] isEqualToString:@"ID"],
              @"[[%@ replacementIdentifier:@""] isEqualToString:%@]",
              [testString replacementIdentifier:@""], @"ID");

    testString = @"user_id";

    XCTAssert([[testString replacementIdentifier:@""] isEqualToString:@"UserID"],
              @"[[%@ replacementIdentifier:@""] isEqualToString:%@]",
              [testString replacementIdentifier:@""], @"UserID");
}

- (void)testLowerCaseFirstLetter
{
    NSString *testString = @"FirstName";

    XCTAssert([[testString lowerCaseFirstLetter] isEqualToString:@"firstName"],
              @"[[%@ lowerCaseFirstLetter] isEqualToString:%@]",
              [testString lowerCaseFirstLetter], @"firstName");
}

- (void)testRemoteString
{
    // One letter

    NSString *localKey = @"age";
    NSString *remoteKey = @"age";

    XCTAssert([remoteKey isEqualToString:[localKey remoteString]],
              @"[%@ isEqualToString:%@",
              localKey, [localKey remoteString]);

    localKey = @"ID";
    remoteKey = @"id";

    XCTAssert([remoteKey isEqualToString:[localKey remoteString]],
              @"[%@ isEqualToString:%@",
              localKey, [localKey remoteString]);

    localKey = @"PDF";
    remoteKey = @"pdf";

    XCTAssert([remoteKey isEqualToString:[localKey remoteString]],
              @"[%@ isEqualToString:%@",
              localKey, [localKey remoteString]);

    // Two letter

    localKey = @"driverIdentifier";
    remoteKey = @"driver_identifier";

    XCTAssert([remoteKey isEqualToString:[localKey remoteString]],
              @"[%@ isEqualToString:%@",
              remoteKey, [localKey remoteString]);

    localKey = @"userID";
    remoteKey = @"user_id";

    XCTAssert([remoteKey isEqualToString:[localKey remoteString]],
              @"[%@ isEqualToString:%@",
              remoteKey, [localKey remoteString]);
}

- (void)testLocalString
{
    // One letter

    NSString *remoteKey = @"age";
    NSString *localKey = @"age";

    XCTAssert([localKey isEqualToString:[remoteKey localString]],
              @"[%@ isEqualToString:%@",
              localKey, [remoteKey localString]);

    remoteKey = @"id";
    localKey = @"ID";

    XCTAssert([localKey isEqualToString:[remoteKey localString]],
              @"[%@ isEqualToString:%@",
              localKey, [remoteKey localString]);

    remoteKey = @"pdf";
    localKey = @"PDF";

    XCTAssert([localKey isEqualToString:[remoteKey localString]],
              @"[%@ isEqualToString:%@",
              localKey, [remoteKey localString]);

    // Two letters

    remoteKey = @"driver_identifier";
    localKey = @"driverIdentifier";

    XCTAssert([localKey isEqualToString:[remoteKey localString]],
              @"[%@ isEqualToString:%@",
              localKey, [remoteKey localString]);

    remoteKey = @"user_id";
    localKey = @"userID";

    XCTAssert([localKey isEqualToString:[remoteKey localString]],
              @"[%@ isEqualToString:%@",
              localKey, [remoteKey localString]);
}

#pragma mark - Property Mapper

- (void)testDictionaryKeys
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssert((dictionary[@"first_name"] && dictionary[@"last_name"]), @"Dictionary keys are present");
}

- (void)testDictionaryValues
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    __block BOOL valid = YES;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *localString = [key localString];
        id value = [self.testUser valueForKey:localString];

        if (![value isEqual:obj]) {
            *stop = YES;
            valid = NO;
        }
    }];

    XCTAssert(valid, @"Dictionary values match object values");
}

- (void)testFillManagedObjectWithDictionary
{
    NSDictionary *values = @{
        @"first_name" : @"Jane",
        @"last_name"  : @"Hyperseed"
    };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssert(([[self.testUser valueForKey:@"firstName"] isEqualToString:values[@"first_name"]]),
              @"Sex change successful");
}

- (void)testUpdatingExistingValueWithNull
{
    NSDictionary *values = @{
                             @"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed"
                             };

    [self.testUser hyp_fillWithDictionary:values];

    NSDictionary *updatedValues = @{
                             @"first_name" : [NSNull new],
                             @"last_name"  : @"Hyperseed"
                             };

    [self.testUser hyp_fillWithDictionary:updatedValues];

    XCTAssert(([self.testUser valueForKey:@"firstName"] == nil), @"Update successful");
}

- (void)testAgeNumber
{
    NSDictionary *values = @{
                             @"age" : @24
                             };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssert(([[self.testUser valueForKey:@"age"] isEqualToNumber:values[@"age"]]),
              @"Number conversion successful");
}

- (void)testAgeString
{
    NSDictionary *values = @{
                             @"age" : @"24"
                             };

    [self.testUser hyp_fillWithDictionary:values];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    NSNumber *age = [formatter numberFromString:values[@"age"]];

    XCTAssert(([[self.testUser valueForKey:@"age"] isEqualToNumber:age]),
              @"Number conversion successful");
}

- (void)testBornDate
{
    NSDictionary *values = @{
                             @"birth_date" : @"1989-02-14T00:00:00+00:00"
                             };

    [self.testUser hyp_fillWithDictionary:values];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *date = [dateFormat dateFromString:@"1989-02-14"];

    XCTAssert(([[self.testUser valueForKey:@"birthDate"] isEqualToDate:date]),
              @"Date conversion successful");
}

- (void)testUpdate
{
    NSDictionary *values = @{
                             @"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed",
                             @"age" : @30
                             };

    [self.testUser hyp_fillWithDictionary:values];

    NSDictionary *updatedValues = @{
                             @"first_name" : @"Jeanet"
                             };

    [self.testUser hyp_fillWithDictionary:updatedValues];

    XCTAssert(([[self.testUser valueForKey:@"firstName"] isEqualToString:updatedValues[@"first_name"]]) &&
              ([[self.testUser valueForKey:@"lastName"] isEqualToString:values[@"last_name"]]),
              @"Update successful");
}

- (void)testUpdateIgnoringEqualValues
{
    NSDictionary *values = @{
                             @"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed",
                             @"age" : @30
                             };

    [self.testUser hyp_fillWithDictionary:values];

    [self.testUser.managedObjectContext save:nil];

    NSDictionary *updatedValues = @{
                                    @"first_name" : @"Jane",
                                    @"last_name"  : @"Hyperseed",
                                    @"age" : @30
                                    };

    [self.testUser hyp_fillWithDictionary:updatedValues];

    XCTAssert(!self.testUser.hasChanges, @"Ignored values successfully!");
}

- (void)testAcronyms
{
    NSDictionary *values = @{
                             @"user_id" : @100
                             };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssert(([[self.testUser valueForKey:@"userID"] isEqualToNumber:@100]),
              @"Update successful");
}

@end
