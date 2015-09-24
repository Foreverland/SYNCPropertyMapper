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

#pragma mark hyp_dictionary

/*
{
    "age_of_person" = 25;
    "birth_date" = "2015-09-24T16:01:59+02:00";
    "contract_id" = 235;
    "created_at" = "2015-09-24T16:01:59+02:00";
    description = "John Description";
    "driver_identifier_str" = ABC8283;
    expenses = <62706c69 73743030 d4010203 0405061e 1f582476 65727369 6f6e5824 6f626a65 63747359 24617263 68697665 72542474 6f701200 0186a0a7 07081314 15161755 246e756c 6cd3090a 0b0c0f12 574e532e 6b657973 5a4e532e 6f626a65 63747356 24636c61 7373a20d 0e800280 03a21011 80048005 8006556a 75696365 5463616b 65233fe0 00000000 00002340 29000000 000000d2 18191a1b 5a24636c 6173736e 616d6558 24636c61 73736573 5c4e5344 69637469 6f6e6172 79a21c1d 5c4e5344 69637469 6f6e6172 79584e53 4f626a65 63745f10 0f4e534b 65796564 41726368 69766572 d1202154 726f6f74 80010811 1a232d32 373f454c 545f6669 6b6d7072 74767c81 8a9398a3 acb9bcc9 d2e4e7ec 00000000 00000101 00000000 00000022 00000000 00000000 00000000 000000ee>;
    "first_name" = John;
    hobbies = <62706c69 73743030 d4010203 0405061b 1c582476 65727369 6f6e5824 6f626a65 63747359 24617263 68697665 72542474 6f701200 0186a0a7 07081112 13141555 246e756c 6cd2090a 0b105a4e 532e6f62 6a656374 73562463 6c617373 a40c0d0e 0f800280 03800480 05800658 466f6f74 62616c6c 56536f63 63657254 436f6465 594d6f72 6520636f 6465d216 1718195a 24636c61 73736e61 6d655824 636c6173 73657357 4e534172 726179a2 181a584e 534f626a 6563745f 100f4e53 4b657965 64417263 68697665 72d11d1e 54726f6f 74800108 111a232d 32373f45 4a555c61 63656769 6b747b80 8a8f9aa3 abaeb7c9 ccd10000 00000000 01010000 00000000 001f0000 00000000 00000000 00000000 00d3>;
    id = 111;
    "ignore_transformable" = "<null>";
    "ignored_parameter" = "<null>";
    "last_name" = Hyperseed;
    "notes_attributes" =     {
        0 =         {
            "_destroy" = 1;
            id = 14;
            text = "This is the text for the note 14";
        };
        1 =         {
            id = 1;
            text = "This is the text for the note 1";
        };
        2 =         {
            id = 7;
            text = "This is the text for the note 7";
        };
    };
    "number_of_attendes" = 30;
    type = Manager;
    "updated_at" = "2015-09-24T16:01:59+02:00";
}
*/

- (void)testDictionaryKeysNotNil {
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
    comparedDictionary[@"ignore_transformable"] = [NSNull null];
    comparedDictionary[@"ignored_parameter"] = [NSNull null];
    comparedDictionary[@"last_name"] = @"Hyperseed";

    NSDictionary *note1 = @{@"id" : @1,
                            @"text" : @"This is the text for the note 1"};
    NSDictionary *note2 = @{@"id" : @7,
                            @"text" : @"This is the text for the note 7"};
    NSDictionary *note3 = @{@"_destroy" : @1,
                            @"id" : @14,
                            @"text" : @"This is the text for the note 14"};

    comparedDictionary[@"notes_attributes"] = @{@0 : note1, @1 : note2, @2 : note3};
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

    XCTAssertTrue([dictionary[@"driver_identifier_str"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"first_name"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"last_name"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"description"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"id"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"type"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"created_at"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"updated_at"] isKindOfClass:[NSString class]]);

    XCTAssertTrue([dictionary[@"number_of_attendes"] isKindOfClass:[NSNumber class]]);

    XCTAssertTrue([dictionary[@"ignored_parameter"] isKindOfClass:[NSNull class]]);

    XCTAssertTrue([dictionary[@"hobbies"] isKindOfClass:[NSData class]]);

    XCTAssertTrue([dictionary[@"expenses"] isKindOfClass:[NSData class]]);
}

- (void)testDictionaryValues {
    DATAStack *dataStack = [self dataStack];
    User *user = [self userUsingDataStack:dataStack];
    NSDictionary *dictionary = [user hyp_dictionary];

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
