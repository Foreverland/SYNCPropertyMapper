@import Foundation;
@import CoreData;

@class User;

@interface Company : NSManagedObject

@property (nonatomic, retain) NSNumber * companyID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) User *user;

@end
