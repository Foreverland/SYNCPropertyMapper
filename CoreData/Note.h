#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Note : NSManagedObject

@property (nonatomic, retain) NSNumber * destroy;
@property (nonatomic, retain) NSNumber * remoteID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * love;
@property (nonatomic, retain) User *user;

@end
