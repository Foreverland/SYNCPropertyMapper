//
//  Market+CoreDataProperties.h
//  Pod
//
//  Created by Elvis Nuñez on 06/10/15.
//  Copyright © 2015 Example. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Market.h"

NS_ASSUME_NONNULL_BEGIN

@interface Market (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *otherAttribute;
@property (nullable, nonatomic, retain) NSString *uniqueId;

@end

NS_ASSUME_NONNULL_END
