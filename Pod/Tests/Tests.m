@import CoreData;
@import XCTest;

#import "NSManagedObject+HYPPropertyMapper.h"

#import "User.h"
#import "Note.h"
#import "Company.h"
#import "Market.h"
#import "DATAStack.h"

@interface Tests : XCTestCase

@property (nonatomic) NSDate *testDate;

@end

@implementation Tests

- (NSDate *)testDate {
    if (!_testDate) {
        _testDate = [NSDate date];
    }

    return _testDate;
}

#pragma mark - Set up

- (DATAStack *)dataStack {
    return [[DATAStack alloc] initWithModelName:@"Model"
                                         bundle:[NSBundle bundleForClass:[self class]]
                                      storeType:DATAStackInMemoryStoreType];
}
- (id)entityNamed:(NSString *)entityName inContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:context];
}

- (User *)userUsingDataStack:(DATAStack *)dataStack {
    User *user = [self entityNamed:@"User" inContext:dataStack.mainContext];
    user.age = @25;
    user.birthDate = self.testDate;
    user.contractID = @235;
    user.driverIdentifier = @"ABC8283";
    user.firstName = @"John";
    user.lastName = @"Hyperseed";
    user.userDescription = @"John Description";
    user.remoteID = @111;
    user.userType = @"Manager";
    user.createdAt = self.testDate;
    user.updatedAt = self.testDate;
    user.numberOfAttendes = @30;
    user.hobbies = [NSKeyedArchiver archivedDataWithRootObject:@[@"Football",
                                                                 @"Soccer",
                                                                 @"Code",
                                                                 @"More code"]];
    user.expenses = [NSKeyedArchiver archivedDataWithRootObject:@{@"cake" : @12.50,
                                                                  @"juice" : @0.50}];

    Note *note = [self noteWithID:@1 inContext:dataStack.mainContext];
    note.user = user;

    note = [self noteWithID:@14 inContext:dataStack.mainContext];
    note.user = user;
    note.destroy = @YES;

    note = [self noteWithID:@7 inContext:dataStack.mainContext];
    note.user = user;

    note = [self entityNamed:@"Note" inContext:dataStack.mainContext];
    note.user = user;

    note = [self entityNamed:@"Note" inContext:dataStack.mainContext];
    note.user = user;

    Company *company = [self companyWithID:@1 andName:@"Facebook" inContext:dataStack.mainContext];
    company.user = user;

    return user;
}

- (Note *)noteWithID:(NSNumber *)remoteID
           inContext:(NSManagedObjectContext *)context {
    Note *note = [self entityNamed:@"Note" inContext:context];
    note.remoteID = remoteID;
    note.text = [NSString stringWithFormat:@"This is the text for the note %@", remoteID];

    return note;
}

- (Company *)companyWithID:(NSNumber *)remoteID
                   andName:(NSString *)name
                 inContext:(NSManagedObjectContext *)context {
    Company *company = [self entityNamed:@"Company" inContext:context];
    company.remoteID = remoteID;
    company.name = name;

    return company;
}

#pragma mark - hyp_dictionary

- (void)testDictionaryNoRelationships {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    NSString *resultDateString = [formatter stringFromDate:self.testDate];

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    NSDictionary *dictionary = [user hyp_dictionaryUsingRelationshipType:HYPPropertyMapperRelationshipTypeNone];
    NSMutableDictionary *comparedDictionary = [NSMutableDictionary new];
    comparedDictionary[@"age_of_person"] = @25;
    comparedDictionary[@"birth_date"] = resultDateString;
    comparedDictionary[@"contract_id"] = @235;
    comparedDictionary[@"created_at"] = resultDateString;
    comparedDictionary[@"description"] = @"John Description";
    comparedDictionary[@"driver_identifier_str"] = @"ABC8283";
    comparedDictionary[@"expenses"] = [NSKeyedArchiver archivedDataWithRootObject:@{@"cake" : @12.50,
                                                                                    @"juice" : @0.50}];
    comparedDictionary[@"first_name"] = @"John";
    comparedDictionary[@"hobbies"] = [NSKeyedArchiver archivedDataWithRootObject:@[@"Football",
                                                                                   @"Soccer",
                                                                                   @"Code",
                                                                                   @"More code"]];
    comparedDictionary[@"id"] = @111;
    comparedDictionary[@"ignored_parameter"] = [NSNull null];
    comparedDictionary[@"last_name"] = @"Hyperseed";
    comparedDictionary[@"number_of_attendes"] = @30;
    comparedDictionary[@"type"] = @"Manager";
    comparedDictionary[@"updated_at"] = resultDateString;

    XCTAssertEqualObjects(dictionary, comparedDictionary);
}

- (void)testDictionaryArrayRelationships {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    NSString *resultDateString = [formatter stringFromDate:self.testDate];

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    NSDictionary *dictionary = [user hyp_dictionaryUsingRelationshipType:HYPPropertyMapperRelationshipTypeArray];
    NSMutableDictionary *comparedDictionary = [NSMutableDictionary new];
    comparedDictionary[@"age_of_person"] = @25;
    comparedDictionary[@"birth_date"] = resultDateString;
    comparedDictionary[@"contract_id"] = @235;
    comparedDictionary[@"created_at"] = resultDateString;
    comparedDictionary[@"description"] = @"John Description";
    comparedDictionary[@"driver_identifier_str"] = @"ABC8283";
    comparedDictionary[@"expenses"] = [NSKeyedArchiver archivedDataWithRootObject:@{@"cake" : @12.50,
                                                                                    @"juice" : @0.50}];
    comparedDictionary[@"first_name"] = @"John";
    comparedDictionary[@"hobbies"] = [NSKeyedArchiver archivedDataWithRootObject:@[@"Football",
                                                                                   @"Soccer",
                                                                                   @"Code",
                                                                                   @"More code"]];
    comparedDictionary[@"id"] = @111;
    comparedDictionary[@"ignored_parameter"] = [NSNull null];
    comparedDictionary[@"last_name"] = @"Hyperseed";

    NSArray *notes = dictionary[@"notes"];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    NSArray *sortedNotes = [notes sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    mutableDictionary[@"notes"] = sortedNotes;
    dictionary = [mutableDictionary copy];

    NSDictionary *note1 = @{@"id" : @1,
                            @"text" : @"This is the text for the note 1"};
    NSDictionary *note2 = @{@"id" : @7,
                            @"text" : @"This is the text for the note 7"};
    NSDictionary *note3 = @{@"destroy" : @1,
                            @"id" : @14,
                            @"text" : @"This is the text for the note 14"};
    comparedDictionary[@"notes"] = @[note1, note2, note3];
    comparedDictionary[@"number_of_attendes"] = @30;
    comparedDictionary[@"type"] = @"Manager";
    comparedDictionary[@"updated_at"] = resultDateString;

    XCTAssertEqualObjects(dictionary, comparedDictionary);
}

- (void)testDictionaryNestedRelationships {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    NSString *resultDateString = [formatter stringFromDate:self.testDate];

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    NSDictionary *dictionary = [user hyp_dictionary];
    NSMutableDictionary *comparedDictionary = [NSMutableDictionary new];
    comparedDictionary[@"age_of_person"] = @25;
    comparedDictionary[@"birth_date"] = resultDateString;
    comparedDictionary[@"contract_id"] = @235;
    comparedDictionary[@"created_at"] = resultDateString;
    comparedDictionary[@"description"] = @"John Description";
    comparedDictionary[@"driver_identifier_str"] = @"ABC8283";
    comparedDictionary[@"expenses"] = [NSKeyedArchiver archivedDataWithRootObject:@{@"cake" : @12.50,
                                                                                    @"juice" : @0.50}];
    comparedDictionary[@"first_name"] = @"John";
    comparedDictionary[@"hobbies"] = [NSKeyedArchiver archivedDataWithRootObject:@[@"Football",
                                                                                   @"Soccer",
                                                                                   @"Code",
                                                                                   @"More code"]];
    comparedDictionary[@"id"] = @111;
    comparedDictionary[@"ignored_parameter"] = [NSNull null];
    comparedDictionary[@"last_name"] = @"Hyperseed";

    NSDictionary *notesDictionary = dictionary[@"notes_attributes"];
    NSArray *notes = notesDictionary.allValues;
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    NSArray *sortedNotes = [notes sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    NSMutableDictionary *mutableDictionary = [dictionary mutableCopy];
    mutableDictionary[@"notes_attributes"] = sortedNotes;
    dictionary = [mutableDictionary copy];

    NSDictionary *note1 = @{@"id" : @1,
                            @"text" : @"This is the text for the note 1"};
    NSDictionary *note2 = @{@"id" : @7,
                            @"text" : @"This is the text for the note 7"};
    NSDictionary *note3 = @{@"_destroy" : @1,
                            @"id" : @14,
                            @"text" : @"This is the text for the note 14"};
    comparedDictionary[@"notes_attributes"] = @[note1, note2, note3];
    comparedDictionary[@"number_of_attendes"] = @30;
    comparedDictionary[@"type"] = @"Manager";
    comparedDictionary[@"updated_at"] = resultDateString;

    XCTAssertEqualObjects(dictionary, comparedDictionary);
}

- (void)testDictionaryValuesKindOfClass {
    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    NSDictionary *dictionary = [user hyp_dictionary];

    XCTAssertTrue([dictionary[@"age_of_person"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"birth_date"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"contract_id"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"created_at"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"description"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"driver_identifier_str"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"expenses"] isKindOfClass:[NSData class]]);

    XCTAssertTrue([dictionary[@"first_name"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"hobbies"] isKindOfClass:[NSData class]]);

    XCTAssertTrue([dictionary[@"id"] isKindOfClass:[NSNumber class]]);

    XCTAssertNil(dictionary[@"ignore_transformable"]);

    XCTAssertTrue([dictionary[@"ignored_parameter"] isKindOfClass:[NSNull class]]);

    XCTAssertTrue([dictionary[@"last_name"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"notes_attributes"] isKindOfClass:[NSDictionary class]]);

    XCTAssertTrue([dictionary[@"number_of_attendes"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"type"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"updated_at"] isKindOfClass:[NSString class]]);
}

#pragma mark - hyp_fillWithDictionary

- (void)testFillManagedObjectWithDictionary {
    NSDictionary *values = @{@"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed"};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([user valueForKey:@"firstName"], values[@"first_name"]);
}

- (void)testUpdatingExistingValueWithNull {
    NSDictionary *values = @{@"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed"};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    NSDictionary *updatedValues = @{@"first_name" : [NSNull new],
                                    @"last_name"  : @"Hyperseed"};

    [user hyp_fillWithDictionary:updatedValues];

    XCTAssertNil([user valueForKey:@"firstName"]);
}

- (void)testAgeNumber {
    NSDictionary *values = @{@"age" : @24};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([user valueForKey:@"age"], values[@"age"]);
}

- (void)testAgeString {
    NSDictionary *values = @{@"age" : @"24"};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    NSNumberFormatter *formatter = [NSNumberFormatter new];
    NSNumber *age = [formatter numberFromString:values[@"age"]];

    XCTAssertEqualObjects([user valueForKey:@"age"], age);
}

- (void)testBornDate {
    NSDictionary *values = @{@"birth_date" : @"1989-02-14T00:00:00+00:00"};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *date = [dateFormat dateFromString:@"1989-02-14"];

    XCTAssertEqualObjects([user valueForKey:@"birthDate"], date);
}

- (void)testUpdate {
    NSDictionary *values = @{@"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed",
                             @"age" : @30};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    NSDictionary *updatedValues = @{@"first_name" : @"Jeanet"};

    [user hyp_fillWithDictionary:updatedValues];

    XCTAssertEqualObjects([user valueForKey:@"firstName"], updatedValues[@"first_name"]);

    XCTAssertEqualObjects([user valueForKey:@"lastName"], values[@"last_name"]);
}

- (void)testUpdateIgnoringEqualValues {
    NSDictionary *values = @{@"first_name" : @"Jane",
                             @"last_name"  : @"Hyperseed",
                             @"age" : @30};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    [user.managedObjectContext save:nil];

    NSDictionary *updatedValues = @{@"first_name" : @"Jane",
                                    @"last_name"  : @"Hyperseed",
                                    @"age" : @30};

    [user hyp_fillWithDictionary:updatedValues];

    XCTAssertFalse(user.hasChanges);
}

- (void)testAcronyms {
    NSDictionary *values = @{@"contract_id" : @100};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([user valueForKey:@"contractID"], @100);
}

- (void)testArrayStorage {
    NSDictionary *values = @{@"hobbies" : @[@"football",
                                            @"soccer",
                                            @"code"]};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:user.hobbies][0], @"football");

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:user.hobbies][1], @"soccer");

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:user.hobbies][2], @"code");
}

- (void)testDictionaryStorage {
    NSDictionary *values = @{@"expenses" : @{@"cake" : @12.50,
                                             @"juice" : @0.50}};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:user.expenses][@"cake"], @12.50);

    XCTAssertEqualObjects([NSKeyedUnarchiver unarchiveObjectWithData:user.expenses][@"juice"], @0.50);
}

- (void)testReservedWords {
    NSDictionary *values = @{@"id": @100,
                             @"description": @"This is the description?",
                             @"type": @"user type"};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    XCTAssertEqualObjects([user valueForKey:@"remoteID"], @100);

    XCTAssertEqualObjects([user valueForKey:@"userDescription"], @"This is the description?");

    XCTAssertEqualObjects([user valueForKey:@"userType"], @"user type");
}

- (void)testCreatedAt {
    NSDictionary *values = @{@"created_at" : @"2014-01-01T00:00:00+00:00",
                             @"updated_at" : @"2014-01-02",
                             @"number_of_attendes": @20};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = @"yyyy-MM-dd";
    dateFormat.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSDate *createdAt = [dateFormat dateFromString:@"2014-01-01"];
    NSDate *updatedAt = [dateFormat dateFromString:@"2014-01-02"];

    XCTAssertEqualObjects([user valueForKey:@"createdAt"], createdAt);

    XCTAssertEqualObjects([user valueForKey:@"updatedAt"], updatedAt);

    XCTAssertEqualObjects([user valueForKey:@"numberOfAttendes"], @20);
}

- (void)testCustomRemoteKeys {
    NSDictionary *values = @{@"age_of_person" : @20,
                             @"driver_identifier_str" : @"123"};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    XCTAssertEqualObjects(user.age, @20);
    XCTAssertEqualObjects(user.driverIdentifier, @"123");
}

- (void)testIgnoredTransformables {
    NSDictionary *values = @{@"ignoreTransformable" : @"I'm going to be ignored"};

    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    [user hyp_fillWithDictionary:values];

    XCTAssertNil(user.ignoreTransformable);
}

- (void)testCustomKey {
    DATAStack *dataStack = [self dataStack];

    NSDictionary *values = @{@"id": @"1",
                             @"other_attribute": @"Market 1"};
    
    Market *market = [self entityNamed:@"Market" inContext:dataStack.mainContext];

    [market hyp_fillWithDictionary:values];

    XCTAssertEqualObjects(market.uniqueId, @"1");
    XCTAssertEqualObjects(market.otherAttribute, @"Market 1");
}

@end
