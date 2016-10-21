@import XCTest;

#import "NSString+SYNCInflections.h"

@interface NSString (PrivateInflections)

- (BOOL)hyp_containsWord:(NSString *)word;
- (NSString *)hyp_lowerCaseFirstLetter;
- (NSString *)hyp_replaceIdentifierWithString:(NSString *)replacementString;

@end

@interface NSString_SYNCInflectionsTests : XCTestCase

@end

@implementation NSString_SYNCInflectionsTests

#pragma mark - Inflections

- (void)testReplacementIdentifier {
    NSString *testString = @"first_name";

    XCTAssertEqualObjects([testString hyp_replaceIdentifierWithString:@""], @"FirstName");

    testString = @"id";

    XCTAssertEqualObjects([testString hyp_replaceIdentifierWithString:@""], @"ID");

    testString = @"user_id";

    XCTAssertEqualObjects([testString hyp_replaceIdentifierWithString:@""], @"UserID");
}

- (void)testLowerCaseFirstLetter {
    NSString *testString = @"FirstName";

    XCTAssertEqualObjects([testString hyp_lowerCaseFirstLetter], @"firstName");
}

- (void)testRemoteString {
    NSString *localKey = @"age";
    NSString *remoteKey = @"age";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);

    localKey = @"id";
    remoteKey = @"id";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);

    localKey = @"pdf";
    remoteKey = @"pdf";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);

    localKey = @"driverIdentifier";
    remoteKey = @"driver_identifier";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);

    localKey = @"integer16";
    remoteKey = @"integer16";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);

    localKey = @"userID";
    remoteKey = @"user_id";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);

    localKey = @"createdAt";
    remoteKey = @"created_at";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);

    localKey = @"userIDFirst";
    remoteKey = @"user_id_first";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);

    localKey = @"OrderedUser";
    remoteKey = @"ordered_user";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_snakeCase]);
}

- (void)testLocalString {
    NSString *remoteKey = @"age";
    NSString *localKey = @"age";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_camelCase]);

    remoteKey = @"id";
    localKey = @"id";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_camelCase]);

    remoteKey = @"pdf";
    localKey = @"pdf";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_camelCase]);

    remoteKey = @"driver_identifier";
    localKey = @"driverIdentifier";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_camelCase]);

    remoteKey = @"integer16";
    localKey = @"integer16";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_camelCase]);

    remoteKey = @"user_id";
    localKey = @"userID";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_camelCase]);

    remoteKey = @"updated_at";
    localKey = @"updatedAt";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_camelCase]);

    remoteKey = @"user_id_first";
    localKey = @"userIDFirst";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_camelCase]);

    remoteKey = @"test_!_key";

    XCTAssertNil([remoteKey hyp_camelCase]);
}

- (void)testConcurrentAccess {
	dispatch_queue_t concurrentQueue = dispatch_queue_create("com.syncdb.test", DISPATCH_QUEUE_CONCURRENT);

	dispatch_apply(6000, concurrentQueue, ^(const size_t i){
		[self testLocalString];
		[self testRemoteString];
	});

}

@end
