import XCTest
import CoreData
import DATAStack

@objc class Helper: NSObject {
    class func dataStackWithModelName(modelName: String) -> DATAStack {
        let bundle = NSBundle(forClass: Helper.self)
        let dataStack = DATAStack(modelName: modelName, bundle: bundle, storeType: .SQLite)
        return dataStack
    }

    class func countForEntity(entityName: String, inContext context: NSManagedObjectContext) -> Int {
        return self.countForEntity(entityName, predicate: nil, inContext: context)
    }

    class func countForEntity(entityName: String, predicate: NSPredicate?, inContext context: NSManagedObjectContext) -> Int {
        let fetchRequest = NSFetchRequest(entityName: entityName)
        fetchRequest.predicate = predicate
        let count = try! context.countForFetchRequest(fetchRequest)

        return count
    }

    class func fetchEntity(entityName: String, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        return self.fetchEntity(entityName, predicate: nil, sortDescriptors: nil, inContext: context)
    }

    class func fetchEntity(entityName: String, predicate: NSPredicate?, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        return self.fetchEntity(entityName, predicate: predicate, sortDescriptors: nil, inContext: context)
    }

    class func fetchEntity(entityName: String, sortDescriptors: [NSSortDescriptor]?, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        return self.fetchEntity(entityName, predicate: nil, sortDescriptors: sortDescriptors, inContext: context)
    }

    class func fetchEntity(entityName: String, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, inContext context: NSManagedObjectContext) -> [NSManagedObject] {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        let objects = try! context.executeFetchRequest(request) as? [NSManagedObject] ?? [NSManagedObject]()
        return objects
    }

    class func insertEntity(name: String, dataStack: DATAStack) -> NSManagedObject {
        let entity = NSEntityDescription.entityForName(name, inManagedObjectContext: dataStack.mainContext)!
        return NSManagedObject(entity: entity, insertIntoManagedObjectContext: dataStack.mainContext)
    }
}
