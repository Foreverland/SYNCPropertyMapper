@import Foundation;
@import CoreData;

@class User;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) User *user;

@end
