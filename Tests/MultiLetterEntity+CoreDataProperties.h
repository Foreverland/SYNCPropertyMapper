//
//  MultiLetterEntity+CoreDataProperties.h
//  Demo
//
//  Created by Elvis Nuñez on 03/11/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MultiLetterEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiLetterEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *remoteID;
@property (nullable, nonatomic, retain) NSString *multiLetterEntityDescription;

@end

NS_ASSUME_NONNULL_END
