import CoreData
import XCTest
import DATAStack
import NSManagedObject_HYPPropertyMapper

class FillWithDictionaryTests: XCTestCase {
    func testBug112() {
        let dataStack = Helper.dataStackWithModelName("Bug112")

        let owner = Helper.insertEntity("Owner", dataStack: dataStack)
        owner.setValue(1, forKey: "id")

        let taskList = Helper.insertEntity("TaskList", dataStack: dataStack)
        taskList.setValue(1, forKey: "id")
        taskList.setValue(owner, forKey: "owner")

        let task = Helper.insertEntity("Task", dataStack: dataStack)
        task.setValue(1, forKey: "id")
        task.setValue(taskList, forKey: "taskList")
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

        /*
        {
            "id": 1,
            "owner": {
                "id": 1
            },
            "tasks": [
                        {
                            "id": 1,
                            "owner": {
                                "id": 1
                            }
                        }
            ]
        }
        */
        XCTAssertEqual(expected, taskList.hyp_dictionary())

        try! dataStack.drop()
    }
}
