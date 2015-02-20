@import CoreData;
@import XCTest;

#import "NSManagedObject+HYPPropertyMapper.h"

#import "User.h"
#import "Note.h"
#import "Company.h"

@interface NSManagedObject_HYPPropertyMapperTests : XCTestCase

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) User *testUser;
@property (nonatomic, strong) NSArray *arraySortedKeys;

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
    user.remoteID = @111;
    user.userType = @"Manager";
    user.createdDate = [NSDate date];
    user.updatedDate = [NSDate date];
    user.numberOfAttendes = @30;

    Note *note = [self noteWithID:@1];
    note.user = user;

    note = [self noteWithID:@14];
    note.user = user;
    note.destroy = @YES;

    note = [self noteWithID:@7];
    note.user = user;

    note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                         inManagedObjectContext:self.managedObjectContext];
    note.user = user;

    note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                         inManagedObjectContext:self.managedObjectContext];
    note.user = user;

    Company *company = [self companyWithID:@1 andName:@"Facebook"];
    company.user = user;

    return user;
}

- (Note *)noteWithID:(NSNumber *)remoteID
{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                               inManagedObjectContext:self.managedObjectContext];
    note.remoteID = remoteID;
    note.text = [NSString stringWithFormat:@"This is the text for the note %@", remoteID];

    return note;
}

- (Company *)companyWithID:(NSNumber *)remoteID andName:(NSString *)name
{
    Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company"
                                                     inManagedObjectContext:self.managedObjectContext];
    company.remoteID = remoteID;
    company.name = name;

    return company;
}

- (void)setUp
{
    [super setUp];

    self.managedObjectContext = [NSManagedObject_HYPPropertyMapperTests managedObjectContextForTests];

    self.testUser = [self user];

    NSDictionary *dictionary = [self.testUser hyp_dictionary];
    
    self.arraySortedKeys = [self sortArrayOfKeysFromDictionary:dictionary];
}

- (void)tearDown
{
    [self.managedObjectContext rollback];

    [super tearDown];
}

- (NSArray *)sortArrayOfKeysFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *arraySortedKeys = [NSMutableArray arrayWithArray:dictionary.allKeys];

    // Checking and sorting the values of the dictionary to be able to check in the correct order.

    for (NSString *key in dictionary.allKeys) {
        if ([dictionary[key] isKindOfClass:[NSString class]]) {
            if ([dictionary[key] isEqualToString:self.testUser.driverIdentifier]) {
                arraySortedKeys[3] = key;
            } else if ([dictionary[key] isEqualToString:self.testUser.firstName]) {
                arraySortedKeys[4] = key;
            } else if ([dictionary[key] isEqualToString:self.testUser.lastName]) {
                arraySortedKeys[5] = key;
            } else if ([dictionary[key] isEqualToString:self.testUser.userDescription]) {
                arraySortedKeys[6] = key;
            } else if ([dictionary[key] isEqualToString:self.testUser.userType]) {
                arraySortedKeys[8] = key;
            }
        } else if ([dictionary[key] isKindOfClass:[NSDate class]]) {
            if ([dictionary[key] isEqualToDate:self.testUser.createdDate]) {
                arraySortedKeys[9] = key;
            } else if ([dictionary[key] isEqualToDate:self.testUser.updatedDate]) {
                arraySortedKeys[10] = key;
            } else if ([dictionary[key] isEqualToDate:self.testUser.birthDate]) {
                arraySortedKeys[1] = key;
            }
        } else if ([dictionary[key] isKindOfClass:[NSNumber class]]) {
            if (dictionary[key] == self.testUser.age) {
                arraySortedKeys[0] = key;
            } else if (dictionary[key] == self.testUser.contractID) {
                arraySortedKeys[2] = key;
            } else if (dictionary[key] == self.testUser.remoteID) {
                arraySortedKeys[7] = key;
            } else if (dictionary[key] == self.testUser.numberOfAttendes) {
                arraySortedKeys[11] = key;
            }
        } else {
            if (dictionary[key]) {
                arraySortedKeys[12] = key;
            }
        }
    }

    return arraySortedKeys;
}

#pragma mark hyp_dictionary

- (void)testDictionaryKeysNotNil
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    NSArray *arrayWithAllKeys = dictionary.allKeys;

    XCTAssertNotNil(dictionary[arrayWithAllKeys[0]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[1]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[2]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[3]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[4]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[5]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[6]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[7]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[8]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[9]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[10]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[11]]);

    XCTAssertNotNil(dictionary[arrayWithAllKeys[12]]);
}

- (void)testDictionaryValuesKindOfClass
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssertTrue([dictionary[self.arraySortedKeys[0]] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[1]] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[2]] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[3]] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[4]] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[5]] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[6]] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[7]] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[8]] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[9]] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[10]] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[11]] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[self.arraySortedKeys[12]] isKindOfClass:[NSNull class]]);
}

- (void)testDictionaryWithRelationships
{
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssertNotNil([dictionary valueForKey:@"notes_attributes"]);
    XCTAssertTrue([[dictionary valueForKey:@"notes_attributes"] isKindOfClass:[NSDictionary class]]);

    NSDictionary *notes = [dictionary valueForKey:@"notes_attributes"];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    NSArray *sortedNotes = [[notes allValues] sortedArrayUsingDescriptors:@[sortDescriptor]];

    XCTAssertEqual(sortedNotes.count, 3);

    NSDictionary *noteDictionary = [sortedNotes firstObject];
    XCTAssertNotNil(noteDictionary);

    XCTAssertEqualObjects([noteDictionary valueForKey:@"id"], @1);
    XCTAssertEqualObjects([noteDictionary valueForKey:@"text"], @"This is the text for the note 1");

    noteDictionary = [sortedNotes lastObject];
    XCTAssertEqualObjects([noteDictionary valueForKey:@"id"], @14);
    XCTAssertEqualObjects([noteDictionary valueForKey:@"text"], @"This is the text for the note 14");
    XCTAssertEqualObjects([noteDictionary valueForKey:@"_destroy"], @YES);
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
                             @"contract_id" : @100
                             };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"contractID"], @100);
}

- (void)testReservedWords
{
    NSDictionary *values = @{
                             @"id": @100,
                             @"description": @"This is the description?",
                             @"type": @"user type"
                             };

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"remoteID"], @100);

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
