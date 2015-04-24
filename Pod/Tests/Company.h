@import Foundation;
@import CoreData;

@class User;

@interface Company : NSManagedObject

@property (nonatomic) NSNumber *remoteID;
@property (nonatomic) NSString *name;
@property (nonatomic) User *user;

@end
