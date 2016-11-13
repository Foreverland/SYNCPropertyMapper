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

        let result = user.hyp_dictionary(using: .snakeCase)
        XCTAssertEqual(compared as NSDictionary, result as NSDictionary)

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

        let result = user.hyp_dictionary(using: .camelCase)
        XCTAssertEqual(compared as NSDictionary, result as NSDictionary)

        try! dataStack.drop()
    }

    let sampleSnakeCaseJSONWithRelationship = ["inflection_id": 1] as [String : Any]

    func testExportDictionaryWithSnakeCaseRelationshipArray() {
        // Fill in transformable attributes is not supported in Swift 3. Crashes when saving the context.
        let dataStack = Helper.dataStackWithModelName("137")
        let user = NSEntityDescription.insertNewObject(forEntityName: "InflectionUser", into: dataStack.mainContext)
        user.hyp_fill(with: self.sampleSnakeCaseJSONWithRelationship)

        let company = NSEntityDescription.insertNewObject(forEntityName: "InflectionCompany", into: dataStack.mainContext)
        company.setValue(NSNumber(value: 1), forKey: "inflectionID")
        user.setValue(company, forKey: "camelCaseCompany")

        try! dataStack.mainContext.save()

        let compared = [
            "inflection_binary_data": NSNull(),
            "inflection_date": NSNull(),
            "inflection_id": 1,
            "inflection_integer": NSNull(),
            "inflection_string": NSNull(),
            "randomRemoteKey": NSNull(),
            "user_description": NSNull(),
            "camel_case_company": [
                "inflection_id": 1
            ]
            ] as [String : Any]

        let result = user.hyp_dictionary(using: .snakeCase, andRelationshipType: .array)
        print(result)
        XCTAssertEqual(compared as NSDictionary, result as NSDictionary)

        try! dataStack.drop()
    }

    func testExportDictionaryWithCamelCaseRelationshipArray() {
        // Fill in transformable attributes is not supported in Swift 3. Crashes when saving the context.
        let dataStack = Helper.dataStackWithModelName("137")
        let user = NSEntityDescription.insertNewObject(forEntityName: "InflectionUser", into: dataStack.mainContext)
        user.hyp_fill(with: self.sampleSnakeCaseJSONWithRelationship)

        let company = NSEntityDescription.insertNewObject(forEntityName: "InflectionCompany", into: dataStack.mainContext)
        company.setValue(NSNumber(value: 1), forKey: "inflectionID")
        user.setValue(company, forKey: "camelCaseCompany")

        try! dataStack.mainContext.save()

        let compared = [
            "inflectionBinaryData": NSNull(),
            "inflectionDate": NSNull(),
            "inflectionID": 1,
            "inflectionInteger": NSNull(),
            "inflectionString": NSNull(),
            "randomRemoteKey": NSNull(),
            "userDescription": NSNull(),
            "camelCaseCompany": [
                "inflectionID": 1
            ]
            ] as [String : Any]

        let result = user.hyp_dictionary(using: .camelCase, andRelationshipType: .array)
        print(result)
        XCTAssertEqual(compared as NSDictionary, result as NSDictionary)

        try! dataStack.drop()
    }

    func testExportDictionaryWithSnakeCaseRelationshipNested() {
        // Fill in transformable attributes is not supported in Swift 3. Crashes when saving the context.
        let dataStack = Helper.dataStackWithModelName("137")
        let user = NSEntityDescription.insertNewObject(forEntityName: "InflectionUser", into: dataStack.mainContext)
        user.hyp_fill(with: self.sampleSnakeCaseJSONWithRelationship)

        let company = NSEntityDescription.insertNewObject(forEntityName: "InflectionCompany", into: dataStack.mainContext)
        company.setValue(NSNumber(value: 1), forKey: "inflectionID")
        user.setValue(company, forKey: "camelCaseCompany")

        try! dataStack.mainContext.save()

        let compared = [
            "inflection_binary_data": NSNull(),
            "inflection_date": NSNull(),
            "inflection_id": 1,
            "inflection_integer": NSNull(),
            "inflection_string": NSNull(),
            "randomRemoteKey": NSNull(),
            "user_description": NSNull(),
            "camel_case_company_attributes": [
                "inflection_id": 1
            ]
            ] as [String : Any]

        let result = user.hyp_dictionary(using: .snakeCase, andRelationshipType: .nested)
        print(result)
        XCTAssertEqual(compared as NSDictionary, result as NSDictionary)

        try! dataStack.drop()
    }

    func testExportDictionaryWithCamelCaseRelationshipNested() {
        // Fill in transformable attributes is not supported in Swift 3. Crashes when saving the context.
        let dataStack = Helper.dataStackWithModelName("137")
        let user = NSEntityDescription.insertNewObject(forEntityName: "InflectionUser", into: dataStack.mainContext)
        user.hyp_fill(with: self.sampleSnakeCaseJSONWithRelationship)

        let company = NSEntityDescription.insertNewObject(forEntityName: "InflectionCompany", into: dataStack.mainContext)
        company.setValue(NSNumber(value: 1), forKey: "inflectionID")
        user.setValue(company, forKey: "camelCaseCompany")

        try! dataStack.mainContext.save()

        let compared = [
            "inflectionBinaryData": NSNull(),
            "inflectionDate": NSNull(),
            "inflectionID": 1,
            "inflectionInteger": NSNull(),
            "inflectionString": NSNull(),
            "randomRemoteKey": NSNull(),
            "userDescription": NSNull(),
            "camelCaseCompanyAttributes": [
                "inflectionID": 1
            ]
            ] as [String : Any]

        let result = user.hyp_dictionary(using: .camelCase, andRelationshipType: .nested)
        print(result)
        XCTAssertEqual(compared as NSDictionary, result as NSDictionary)
        
        try! dataStack.drop()
    }
}
