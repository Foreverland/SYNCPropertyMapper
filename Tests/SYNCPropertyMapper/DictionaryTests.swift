import CoreData
import XCTest
import DATAStack

class DictionaryTests: XCTestCase {
    let sampleSnakeCaseJSON = [
        "user_description": "reserved",
        "inflection_binary_data": ["one", "two"],
        "inflection_date": "1970-01-01",
        "custom_remote_key": "randomRemoteKey",
        "inflection_id": 1,
        "inflection_string": "string",
        "inflection_integer": 1,
        "ignored_parameter": "ignored",
        "ignore_transformable": "string",
        ] as [String : Any]

    let sampleSnakeCaseJSONWithRelationship = [
        "inflection_id": 1,
        "camel_case_company": [
            "inflection_id": 1
        ]
        ] as [String : Any]

    func testExportDictionaryWithSnakeCase() {
        // Fill in transformable attributes is not supported in Swift 3. Crashes when saving the context.
        let dataStack = Helper.dataStackWithModelName("137")
        let user = NSEntityDescription.insertNewObject(forEntityName: "InflectionUser", into: dataStack.mainContext)
        user.hyp_fill(with: self.sampleSnakeCaseJSON)
        try! dataStack.mainContext.save()

        let compared = [
            "user_description": "reserved",
            "inflection_binary_data": NSKeyedArchiver.archivedData(withRootObject: ["one", "two"]),
            "inflection_date": "1970-01-01T01:00:00+01:00",
            "randomRemoteKey": "randomRemoteKey",
            "inflection_id": 1,
            "inflection_string": "string",
            "inflection_integer": 1
            ] as [String : Any]

        XCTAssertEqual(compared as NSDictionary, user.hyp_dictionary() as NSDictionary)

        try! dataStack.drop()
    }

    func testExportDictionaryWithCamelCase() {
        // Fill in transformable attributes is not supported in Swift 3. Crashes when saving the context.
        let dataStack = Helper.dataStackWithModelName("137")
        let user = NSEntityDescription.insertNewObject(forEntityName: "InflectionUser", into: dataStack.mainContext)
        user.hyp_fill(with: self.sampleSnakeCaseJSON)
        try! dataStack.mainContext.save()

        let compared = [
            "userDescription": "reserved",
            "inflectionBinaryData": NSKeyedArchiver.archivedData(withRootObject: ["one", "two"]),
            "inflectionDate": "1970-01-01T01:00:00+01:00",
            "randomRemoteKey": "randomRemoteKey",
            "inflectionID": 1,
            "inflectionString": "string",
            "inflectionInteger": 1
            ] as [String : Any]

        XCTAssertEqual(compared as NSDictionary, user.hyp_dictionary(using: .camelCase) as NSDictionary)

        try! dataStack.drop()
    }
}
