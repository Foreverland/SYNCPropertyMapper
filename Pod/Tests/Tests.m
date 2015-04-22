@import CoreData;
@import XCTest;

#import "NSManagedObject+HYPPropertyMapper.h"

#import "User.h"
#import "Note.h"
#import "Company.h"
#import "Market.h"
#import "DATAStack.h"

@interface Tests : XCTestCase

@property (nonatomic) User *testUser;

@end

@implementation Tests

#pragma mark - Set up

- (NSManagedObjectContext *)managedObjectContext {
    DATAStack *dataStack = [[DATAStack alloc] initWithModelName:@"Model"
                                                         bundle:[NSBundle bundleForClass:[self class]]
                                                      storeType:DATAStackInMemoryStoreType];
    return dataStack.mainContext;
}

- (User *)user {
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
    user.createdAt = [NSDate date];
    user.updatedAt = [NSDate date];
    user.numberOfAttendes = @30;
    user.hobbies = [NSKeyedArchiver archivedDataWithRootObject:@[@"Football",
                                                                 @"Soccer",
                                                                 @"Code",
                                                                 @"More code"]];
    user.expenses = [NSKeyedArchiver archivedDataWithRootObject:@{@"cake" : @12.50,
                                                                  @"juice" : @0.50}];

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

- (Note *)noteWithID:(NSNumber *)remoteID {
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                               inManagedObjectContext:self.managedObjectContext];
    note.remoteID = remoteID;
    note.text = [NSString stringWithFormat:@"This is the text for the note %@", remoteID];

    return note;
}

- (Company *)companyWithID:(NSNumber *)remoteID andName:(NSString *)name {
    Company *company = [NSEntityDescription insertNewObjectForEntityForName:@"Company"
                                                     inManagedObjectContext:self.managedObjectContext];
    company.remoteID = remoteID;
    company.name = name;

    return company;
}

- (void)setUp {
    [super setUp];

    self.testUser = [self user];
}

#pragma mark hyp_dictionary

- (void)testDictionaryKeysNotNil {
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssertNotNil(dictionary[@"age_of_person"]);

    XCTAssertNotNil(dictionary[@"birth_date"]);

    XCTAssertNotNil(dictionary[@"contract_id"]);

    XCTAssertNotNil(dictionary[@"driver_identifier_str"]);

    XCTAssertNotNil(dictionary[@"first_name"]);

    XCTAssertNotNil(dictionary[@"last_name"]);

    XCTAssertNotNil(dictionary[@"description"]);

    XCTAssertNotNil(dictionary[@"id"]);

    XCTAssertNotNil(dictionary[@"type"]);

    XCTAssertNotNil(dictionary[@"created_at"]);

    XCTAssertNotNil(dictionary[@"updated_at"]);

    XCTAssertNotNil(dictionary[@"number_of_attendes"]);

    XCTAssertNotNil(dictionary[@"ignored_parameter"]);

    XCTAssertNotNil(dictionary[@"hobbies"]);

    XCTAssertNotNil(dictionary[@"expenses"]);
}

- (void)testDictionaryValuesKindOfClass {
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssertTrue([dictionary[@"age_of_person"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"birth_date"] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[@"contract_id"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"driver_identifier_str"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"first_name"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"last_name"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"description"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"id"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"type"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"created_at"] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[@"updated_at"] isKindOfClass:[NSDate class]]);

    XCTAssertTrue([dictionary[@"number_of_attendes"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"ignored_parameter"] isKindOfClass:[NSNull class]]);

    XCTAssertTrue([dictionary[@"hobbies"] isKindOfClass:[NSData class]]);

    XCTAssertTrue([dictionary[@"expenses"] isKindOfClass:[NSData class]]);
}

- (void)testDictionaryValues {
    NSDictionary *dictionary = [self.testUser hyp_dictionary];

    XCTAssertEqualObjects([dictionary valueForKey:@"age_of_person"], @25);
    XCTAssertEqualObjects([dictionary valueForKey:@"contract_id"], @235);
    XCTAssertEqualObjects([dictionary valueForKey:@"driver_identifier_str"], @"ABC8283");
    XCTAssertEqualObjects([dictionary valueForKey:@"first_name"], @"John");
    XCTAssertEqualObjects([dictionary valueForKey:@"description"], @"John Description");

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

- (void)testFillManagedObjectWithDictionary {
    NSDictionary *values = @{@"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed"};

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"firstName"], values[@"first_name"]);
}

- (void)testUpdatingExistingValueWithNull {
    NSDictionary *values = @{@"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed"};

    [self.testUser hyp_fillWithDictionary:values];

    NSDictionary *updatedValues = @{@"first_name" : [NSNull new],
                                    @"last_name"  : @"Hyperseed"};

    [self.testUser hyp_fillWithDictionary:updatedValues];

    XCTAssertNil([self.testUser valueForKey:@"firstName"]);
}

- (void)testAgeNumber {
    NSDictionary *values = @{@"age" : @24};

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"age"], values[@"age"]);
}

- (void)testAgeString {
    NSDictionary *values = @{@"age" : @"24"};

    [self.testUser hyp_fillWithDictionary:values];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    NSNumber *age = [formatter numberFromString:values[@"age"]];

    XCTAssertEqualObjects([self.testUser valueForKey:@"age"], age);
}

- (void)testBornDate {
    NSDictionary *values = @{@"birth_date" : @"1989-02-14T00:00:00+00:00"};

    [self.testUser hyp_fillWithDictionary:values];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *date = [dateFormat dateFromString:@"1989-02-14"];

    XCTAssertEqualObjects([self.testUser valueForKey:@"birthDate"], date);
}

- (void)testUpdate {
    NSDictionary *values = @{@"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed",
                             @"age" : @30};

    [self.testUser hyp_fillWithDictionary:values];

    NSDictionary *updatedValues = @{@"first_name" : @"Jeanet"};

    [self.testUser hyp_fillWithDictionary:updatedValues];

    XCTAssertEqualObjects([self.testUser valueForKey:@"firstName"], updatedValues[@"first_name"]);

    XCTAssertEqualObjects([self.testUser valueForKey:@"lastName"], values[@"last_name"]);
}

- (void)testUpdateIgnoringEqualValues {
    NSDictionary *values = @{@"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed",
                             @"age" : @30};

    [self.testUser hyp_fillWithDictionary:values];

    [self.testUser.managedObjectContext save:nil];

    NSDictionary *updatedValues = @{@"first_name" : @"Jane",
                                    @"last_name"  : @"Hyperseed",
                                    @"age" : @30};

    [self.testUser hyp_fillWithDictionary:updatedValues];

    XCTAssertFalse(self.testUser.hasChanges);
}

- (void)testAcronyms {
    NSDictionary *values = @{@"contract_id" : @100};

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"contractID"], @100);
}

- (void)testArrayStorage {
    NSDictionary *values = @{@"hobbies" : @[@"football",
                                            @"soccer",
                                            @"code"]};

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:self.testUser.hobbies][0], @"football");

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:self.testUser.hobbies][1], @"soccer");

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:self.testUser.hobbies][2], @"code");
}

- (void)testDictionaryStorage {
    NSDictionary *values = @{@"expenses" : @{@"cake" : @12.50,
                                             @"juice" : @0.50}};

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:self.testUser.expenses][@"cake"], @12.50);

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:self.testUser.expenses][@"juice"], @0.50);
}

- (void)testReservedWords {
    NSDictionary *values = @{@"id": @100,
                             @"description": @"This is the description?",
                             @"type": @"user type"};

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([self.testUser valueForKey:@"remoteID"], @100);

    XCTAssertEqualObjects([self.testUser valueForKey:@"userDescription"], @"This is the description?");

    XCTAssertEqualObjects([self.testUser valueForKey:@"userType"], @"user type");
}

- (void)testCreatedAt {
    NSDictionary *values = @{@"created_at" : @"2014-01-01T00:00:00+00:00",
                             @"updated_at" : @"2014-01-02T00:00:00+00:00",
                             @"number_of_attendes": @20};

    [self.testUser hyp_fillWithDictionary:values];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *createdAt = [dateFormat dateFromString:@"2014-01-01"];
    NSDate *updatedAt = [dateFormat dateFromString:@"2014-01-02"];

    XCTAssertEqualObjects([self.testUser valueForKey:@"createdAt"], createdAt);

    XCTAssertEqualObjects([self.testUser valueForKey:@"updatedAt"], updatedAt);

    XCTAssertEqualObjects([self.testUser valueForKey:@"numberOfAttendes"], @20);
}

- (void)testCustomRemoteKeys {
    NSDictionary *values = @{@"age_of_person" : @20,
                             @"driver_identifier_str" : @"123"};

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertEqualObjects(self.testUser.age, @20);
    XCTAssertEqualObjects(self.testUser.driverIdentifier, @"123");
}

- (void)testIgnoredTransformables {
    NSDictionary *values = @{@"ignoreTransformable" : @"I'm going to be ignored"};

    [self.testUser hyp_fillWithDictionary:values];

    XCTAssertNil(self.testUser.ignoreTransformable);
}

- (void)testSomething {
    NSDictionary *values = @{@"id": @"1",
                             @"other_attribute": @"Market 1"};

    Market *market = [NSEntityDescription insertNewObjectForEntityForName:@"Market"
                                                            inManagedObjectContext:self.managedObjectContext];

    [market hyp_fillWithDictionary:values];

    XCTAssertEqualObjects(market.uniqueId, @"1");
    XCTAssertEqualObjects(market.otherAttribute, @"Market 1");
}

@end
