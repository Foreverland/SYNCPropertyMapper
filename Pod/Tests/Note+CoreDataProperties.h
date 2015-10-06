//
//  Note+CoreDataProperties.h
//  Pod
//
//  Created by Elvis Nuñez on 06/10/15.
//  Copyright © 2015 Example. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note.h"

NS_ASSUME_NONNULL_BEGIN

@interface Note (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *destroy;
@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
