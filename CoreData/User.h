@import Foundation;
@import CoreData;

@class Note;

@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSDate * birthDate;
@property (nonatomic, retain) NSNumber * contractID;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSString * driverIdentifier;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * ignoredParameter;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * numberOfAttendes;
@property (nonatomic, retain) NSDate * updatedDate;
@property (nonatomic, retain) NSString * userDescription;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * userType;
@property (nonatomic, retain) NSSet *notes;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
