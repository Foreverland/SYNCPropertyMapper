//
//  Market+CoreDataProperties.h
#import "Market.h"

NS_ASSUME_NONNULL_BEGIN

@interface Market (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *otherAttribute;
@property (nullable, nonatomic, retain) NSString *uniqueId;

@end

NS_ASSUME_NONNULL_END
