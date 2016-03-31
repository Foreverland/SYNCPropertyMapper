//
//  User+CoreDataProperties.h
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *rawSigned;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSDate *birthDate;
@property (nullable, nonatomic, retain) NSNumber *contractID;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *driverIdentifier;
@property (nullable, nonatomic, retain) NSData *expenses;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSData *hobbies;
@property (nullable, nonatomic, retain) NSString *ignoredParameter;
@property (nullable, nonatomic, retain) id ignoreTransformable;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSNumber *numberOfAttendes;
@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) NSDate *updatedAt;
@property (nullable, nonatomic, retain) NSString *userDescription;
@property (nullable, nonatomic, retain) NSString *userType;
@property (nullable, nonatomic, retain) Company *company;
@property (nullable, nonatomic, retain) NSSet<Note *> *notes;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet<Note *> *)values;
- (void)removeNotes:(NSSet<Note *> *)values;

@end

NS_ASSUME_NONNULL_END
