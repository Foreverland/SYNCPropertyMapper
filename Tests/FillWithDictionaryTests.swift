import CoreData
import XCTest
import DATAStack
import NSManagedObject_HYPPropertyMapper

class FillWithDictionaryTests: XCTestCase {
    func testBug112() {
        let dataStack = Helper.dataStackWithModelName("Bug112")

        let owner = Helper.insertEntity("Owner", dataStack: dataStack)
        owner.setValue(1, forKey: "id")

        let tasklist = Helper.insertEntity("Tasklist", dataStack: dataStack)
        tasklist.setValue(1, forKey: "id")
        tasklist.setValue(owner, forKey: "owner")

        let task = Helper.insertEntity("Task", dataStack: dataStack)
        task.setValue(1, forKey: "id")
        task.setValue(tasklist, forKey: "taskList")
        task.setValue(owner, forKey: "owner")

        try! dataStack.mainContext.save()

        let ownerBody = ["id" : 1]
        let taskBoby = [
            "id" : 1,
            "owner" : ownerBody
        ]
        let expected = [
            "id" : 1,
            "owner" : ownerBody,
            "tasks" : [ taskBoby ]
        ]
        XCTAssertEqual(expected, tasklist.hyp_dictionary())
    }
}



