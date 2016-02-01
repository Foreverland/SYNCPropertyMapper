#import "Attributes.h"

NS_ASSUME_NONNULL_BEGIN

@interface Attributes (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *binaryData;
@property (nullable, nonatomic, retain) NSNumber *boolean;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSDecimalNumber *decimal;
@property (nullable, nonatomic, retain) NSNumber *doubleValue;
@property (nullable, nonatomic, retain) NSNumber *floatValue;
@property (nullable, nonatomic, retain) NSNumber *integer16;
@property (nullable, nonatomic, retain) NSNumber *integer32;
@property (nullable, nonatomic, retain) NSNumber *integer64;
@property (nullable, nonatomic, retain) NSString *string;
@property (nullable, nonatomic, retain) id transformable;

@end

NS_ASSUME_NONNULL_END
