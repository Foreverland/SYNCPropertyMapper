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
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    NSAssert(store, @"Should have a store by now");

    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    moc.persistentStoreCoordinator = psc;

    return moc;
}

- (void)setUp
{
    [super setUp];
    self.managedObjectContext = [NSManagedObject_HYPPropertyMapperTests managedObjectContextForTests];

    self.testUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];

    [self.testUser setValue:@"John" forKey:@"firstName"];
    [self.testUser setValue:@"Hyperseed" forKey:@"lastName"];
}

- (void)tearDown
{
    [self.managedObjectContext rollback];
    [super tearDown];
}

#pragma mark - Tests

- (void)testDictionaryKeys
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];
    BOOL converstionSuccessful;

    if (dictionary[@"first_name"] && dictionary[@"last_name"]) {
        converstionSuccessful = YES;
    }

    XCTAssert(converstionSuccessful, @"Dictionary keys are present");
}

- (void)testDictonaryValues
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    __block BOOL valid = YES;
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *localString = [NSManagedObject convertToLocalString:key];
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

    XCTAssert(([[self.testUser valueForKey:@"firstName"] isEqualTo:values[@"first_name"]]), @"Sex change successful");
}

@end
