@import CoreData;

static NSString * const HYPPropertyMapperCustomRemoteKey = @"hyper.remoteKey";

@interface NSManagedObject (HYPPropertyMapper)

/*! Fills the NSManagedObject with the contents of the dictionary
 *  using a convention-over-configuration paradigm mapping the
 *  Core Data attributes to their conterparts in JSON using snake_case.
 */
- (void)hyp_fillWithDictionary:(NSDictionary *)dictionary;

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Includes relationships to other models using Ruby on Rail's nested attributes model.
 *  NSDate objects will be stringified to the ISO-8601 standard.
 * \return NSDictionary of values that can be serialized
 */
- (NSDictionary *)hyp_dictionary;

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Could include relationships to other models using Ruby on Rail's nested attributes model.
 *  NSDate objects will be stringified to the ISO-8601 standard.
 * \param shouldIncludeNestedAttributes - A boolean to indicate weather the NSDictionary should include nested attributes or not.
 * \return NSDictionary of values that can be serialized
 */
- (NSDictionary *)hyp_dictionaryIncludingNestedAttributes:(BOOL)shouldIncludeNestedAttributes;

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Includes relationships to other models using Ruby on Rail's nested attributes model.
 * \param dateFormatter - A custom date formatter that turns NSDate objects into NSString objects. Do not pass nil, instead use the 'hyp_dictionary' method
 * \return NSDictionary of values that can be serialized
 */
- (NSDictionary *)hyp_dictionaryWithDateFormatter:(NSDateFormatter *)formatter;

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Could include relationships to other models using Ruby on Rail's nested attributes model.
 * \param dateFormatter - A custom date formatter that turns NSDate objects into NSString objects. Do not pass nil, instead use the 'hyp_dictionary' method
 * \param shouldIncludeNestedAttributes - A boolean to indicate weather the NSDictionary should include nested attributes or not.
 * \return NSDictionary of values that can be serialized
 */
- (NSDictionary *)hyp_dictionaryWithDateFormatter:(NSDateFormatter *)formatter includingNestedAttributes:(BOOL)shouldIncludeNestedAttributes;

@end
