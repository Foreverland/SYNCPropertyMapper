//
//  Room+CoreDataProperties.h
//  Pod
//
//  Created by Elvis Nuñez on 06/10/15.
//  Copyright © 2015 Example. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Room.h"

NS_ASSUME_NONNULL_BEGIN

@interface Room (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) NSManagedObject *apartment;

@end

NS_ASSUME_NONNULL_END
