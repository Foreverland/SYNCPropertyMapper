@import Foundation;
@import CoreData;

@class User;

@interface Note : NSManagedObject

@property (nonatomic) NSNumber * remoteID;
@property (nonatomic) NSString * text;
@property (nonatomic) NSNumber * destroy;
@property (nonatomic) User *user;

@end
