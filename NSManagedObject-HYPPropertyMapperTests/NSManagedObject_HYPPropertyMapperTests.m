@import CoreData;
@import XCTest;

#import "NSManagedObject+HYPPropertyMapper.h"

#import "User.h"
#import "Note.h"
#import "Company.h"

@interface NSManagedObject_HYPPropertyMapperTests : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) User *testUser;

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

- (User *)user
{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                               inManagedObjectContext:self.managedObjectContext];
    user.age = @25;
    user.birthDate = [NSDate date];
    user.contractID = @235;
    user.driverIdentifier = @"ABC8283";
    user.firstName = @"John";
    user.lastName = @"Hyperseed";
    user.userDescription = @"John Description";
    user.userID = @111;
    user.userType = @"Manager";
    user.createdDate = [NSDate date];
    user.updatedDate = [NSDate date];
    user.numberOfAttendes = @30;

    Note *note = [self noteWithID:@1];
    note.user = user;

    note = [self noteWithID:@14];
    note.user = user;

    note = [self noteWithID:@7];
    note.user = user;

    Company *company = [self companyWithID:@1 andName:@"Facebook"];
    company.user = user;

    return user;
}

- (Note *)noteWithID:(NSNumber *)noteID
{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                                inManagedObjectContext:self.managedObjectContext];
    note.noteID = noteID;
    note.text = [NSString stringWithFormat:@"This is the text for the note %@", noteID];

    return note;
}

- (Company *)companyWithID:(NSNumber *)companyID andName:(NSString *)name
{
    Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company"
                                                     inManagedObjectContext:self.managedObjectContext];
    company.companyID = companyID;
    company.name = name;

    return company;
}

- (void)setUp
{
    [super setUp];

    self.managedObjectContext = [NSManagedObject_HYPPropertyMapperTests managedObjectContextForTests];

    self.testUser = [self user];
}

- (void)tearDown
{
    [self.managedObjectContext rollback];

    [super tearDown];
}

#pragma mark hyp_dictionary

- (void)testDictionaryKeysNotNil
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssertNotNil(dictionary[@"age"]);

    XCTAssertNotNil(dictionary[@"birth_date"]);

    XCTAssertNotNil(dictionary[@"contract_id"]);

    XCTAssertNotNil(dictionary[@"driver_identifier"]);

    XCTAssertNotNil(dictionary[@"first_name"]);

    XCTAssertNotNil(dictionary[@"last_name"]);

    XCTAssertNotNil(dictionary[@"description"]);

    XCTAssertNotNil(dictionary[@"id"]);

    XCTAssertNotNil(dictionary[@"type"]);

    XCTAssertNotNil(dictionary[@"created_at"]);

    XCTAssertNotNil(dictionary[@"updated_at"]);

    XCTAssertNotNil(dictionary[@"number_of_attendes"]);

    XCTAssertNotNil(dictionary[@"ignored_parameter"]);
}

- (void)testDictionaryValuesKindOfClass
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssertTrue([dictionary[@"age"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"birth_date"] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[@"contract_id"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"driver_identifier"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"first_name"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"last_name"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"description"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"id"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"type"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"created_at"] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[@"updated_at"] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[@"number_of_attendes"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"ignored_parameter"] isKindOfClass:[NSNull class]]);
}

- (void)testDictionaryWithRelationships
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssertNotNil([dictionary valueForKey:@"notes"]);
    XCTAssertTrue([[dictionary valueForKey:@"notes"] isKindOfClass:[NSArray class]]);

    NSArray *notes = [dictionary valueForKey:@"notes"];
    XCTAssertTrue(notes.count == 3);

    NSDictionary *noteContainerDictionary = [notes firstObject];
    NSDictionary *noteDictionary = [noteContainerDictionary valueForKey:@"0"];
    XCTAssertNotNil(noteDictionary);

    XCTAssertEqualObjects([noteDictionary valueForKey:@"id"], @1);
    XCTAssertEqualObjects([noteDictionary valueForKey:@"text"], @"This is the text for the note 1");

    noteContainerDictionary = [notes lastObject];
    noteDictionary = [noteContainerDictionary valueForKey:@"2"];
    XCTAssertEqualObjects([noteDictionary valueForKey:@"id"], @14);
    XCTAssertEqualObjects([noteDictionary valueForKey:@"text"], @"This is the text for the note 14");
}

- (void)testFlattenDictionaryWithRelationships
{
    NSDictionary *dictionary = [self.testUser hyp_flatDictionary];

    XCTAssertEqualObjects(dictionary[@"notes[0].id"], @1);
    XCTAssertEqualObjects(dictionary[@"notes[0].text"], @"This is the text for the note 1");
    XCTAssertEqualObjects(dictionary[@"notes[1].id"], @7);
    XCTAssertEqualObjects(dictionary[@"notes[1].text"], @"This is the text for the note 7");
}

#pragma mark - hyp_fillWithDictionary

- (void)testFillManagedObjectWithDictionary
{
    NSDictionary *values = @{
                             @"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed"
                             };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"firstName"], values[@"first_name"]);
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

    XCTAssertNil([self.testUser valueForKey:@"firstName"]);
}

- (void)testAgeNumber
{
    NSDictionary *values = @{
                             @"age" : @24
                             };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"age"], values[@"age"]);
}

- (void)testAgeString
{
    NSDictionary *values = @{
                             @"age" : @"24"
                             };

    [self.testUser hyp_fillWithDictionary:values];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    NSNumber *age = [formatter numberFromString:values[@"age"]];

    XCTAssertEqualObjects([self.testUser valueForKey:@"age"], age);
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

    XCTAssertEqualObjects([self.testUser valueForKey:@"birthDate"], date);
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

    XCTAssertEqualObjects([self.testUser valueForKey:@"firstName"], updatedValues[@"first_name"]);

    XCTAssertEqualObjects([self.testUser valueForKey:@"lastName"], values[@"last_name"]);
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

    XCTAssertFalse(self.testUser.hasChanges);
}

- (void)testAcronyms
{
    NSDictionary *values = @{
                             @"user_id" : @100
                             };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"userID"], @100);
}


- (void)testReservedWords
{
    NSDictionary *values = @{
                             @"id": @100,
                             @"description": @"This is the description?",
                             @"type": @"user type"
                             };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"userID"], @100);

    XCTAssertEqualObjects([self.testUser valueForKey:@"userDescription"], @"This is the description?");

    XCTAssertEqualObjects([self.testUser valueForKey:@"userType"], @"user type");
}

- (void)testCreatedDate
{
    NSDictionary *values = @{
                             @"created_at" : @"2014-01-01T00:00:00+00:00",
                             @"updated_at" : @"2014-01-02T00:00:00+00:00",
                             @"number_of_attendes": @20
                             };

    [self.testUser hyp_fillWithDictionary:values];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *createdDate = [dateFormat dateFromString:@"2014-01-01"];
    NSDate *updatedDate = [dateFormat dateFromString:@"2014-01-02"];

    XCTAssertEqualObjects([self.testUser valueForKey:@"createdDate"], createdDate);

    XCTAssertEqualObjects([self.testUser valueForKey:@"updatedDate"], updatedDate);

    XCTAssertEqualObjects([self.testUser valueForKey:@"numberOfAttendes"], @20);
}

@end
