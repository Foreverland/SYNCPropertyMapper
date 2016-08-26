import CoreData
import XCTest
import DATAStack
import NSManagedObject_HYPPropertyMapper

class FillWithDictionaryTests: XCTestCase {
    func testBug112() {
        let dataStack = Helper.dataStackWithModelName("Bug112")
        let ownerEntity = NSEntityDescription.entityForName("Owner", inManagedObjectContext: dataStack.mainContext)!
        let owner = NSManagedObject(entity: ownerEntity, insertIntoManagedObjectContext: dataStack.mainContext)
        owner.setValue(NSProcessInfo.processInfo().globallyUniqueString, forKey: "id")

        let tasklistEntity = NSEntityDescription.entityForName("Tasklist", inManagedObjectContext: dataStack.mainContext)!
        let tasklist = NSManagedObject(entity: tasklistEntity, insertIntoManagedObjectContext: dataStack.mainContext)
        tasklist.setValue(NSProcessInfo.processInfo().globallyUniqueString, forKey: "id")
        tasklist.setValue(owner, forKey: "owner")

        let taskEntity = NSEntityDescription.entityForName("Task", inManagedObjectContext: dataStack.mainContext)!
        let task = NSManagedObject(entity: taskEntity, insertIntoManagedObjectContext: dataStack.mainContext)
        task.setValue(NSProcessInfo.processInfo().globallyUniqueString, forKey: "id")
        task.setValue(tasklist, forKey: "taskList")
        task.setValue(owner, forKey: "owner")

        try! dataStack.mainContext.save()

        print("Data saved successfully!")
        print("-----")
        print(tasklist)
        print(task)
        print("-----")

        print("Trying to make JSON...")
        print(tasklist.hyp_dictionary())
    }
}