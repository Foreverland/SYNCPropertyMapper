@import Foundation;
@import CoreData;

@class User;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * noteID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * destroy;
@property (nonatomic, retain) User *user;

@end
