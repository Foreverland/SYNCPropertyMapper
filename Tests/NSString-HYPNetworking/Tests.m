@import XCTest;

#import "NSString+HYPNetworking.h"

@interface NSString (PrivateInflections)

- (BOOL)hyp_containsWord:(NSString *)word;
- (NSString *)hyp_lowerCaseFirstLetter;
- (NSString *)hyp_replaceIdentifierWithString:(NSString *)replacementString;

@end

@interface Tests : XCTestCase

@end

@implementation Tests

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

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);

    localKey = @"id";
    remoteKey = @"id";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);

    localKey = @"pdf";
    remoteKey = @"pdf";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);

    localKey = @"driverIdentifier";
    remoteKey = @"driver_identifier";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);

    localKey = @"integer16";
    remoteKey = @"integer16";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);

    localKey = @"userID";
    remoteKey = @"user_id";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);

    localKey = @"createdAt";
    remoteKey = @"created_at";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);

    localKey = @"userIDFirst";
    remoteKey = @"user_id_first";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);

    localKey = @"OrderedUser";
    remoteKey = @"ordered_user";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_remoteString]);
}

- (void)testLocalString {
    NSString *remoteKey = @"age";
    NSString *localKey = @"age";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_localString]);

    remoteKey = @"id";
    localKey = @"id";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_localString]);

    remoteKey = @"pdf";
    localKey = @"pdf";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_localString]);

    remoteKey = @"driver_identifier";
    localKey = @"driverIdentifier";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_localString]);

    remoteKey = @"integer16";
    localKey = @"integer16";

    XCTAssertEqualObjects(remoteKey, [localKey hyp_localString]);

    remoteKey = @"user_id";
    localKey = @"userID";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_localString]);

    remoteKey = @"updated_at";
    localKey = @"updatedAt";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_localString]);

    remoteKey = @"user_id_first";
    localKey = @"userIDFirst";

    XCTAssertEqualObjects(localKey, [remoteKey hyp_localString]);

    remoteKey = @"test_!_key";

    XCTAssertNil([remoteKey hyp_localString]);
}

- (void)testConcurrentAccess {
	dispatch_queue_t concurrentQueue = dispatch_queue_create("com.syncdb.test", DISPATCH_QUEUE_CONCURRENT);

	dispatch_apply(6000, concurrentQueue, ^(const size_t i){
		[self testLocalString];
		[self testRemoteString];
	});

}

@end
