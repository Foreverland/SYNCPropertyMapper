@import CoreData;

static NSString * const HYPPropertyMapperCustomRemoteKey = @"hyper.remoteKey";

@interface NSManagedObject (HYPPropertyMapper)

- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary;

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Includes relationships to other models.
 *  NSDate objects will be stringified to the ISO-8601 standard.
 * \return NSDictionary of values that can be serialized
 */

- (NSDictionary *)hyp_dictionary;

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Includes relationships to other models.
 * \param dateFormatter - A custom date formatter that turns NSDate objects into NSString objects. Do not pass nil, instead use the 'hyp_dictionary' method
 * \return NSDictionary of values that can be serialized
 */

- (NSDictionary *)hyp_dictionaryWithDateFormatter:(NSDateFormatter *)formatter;

@end
