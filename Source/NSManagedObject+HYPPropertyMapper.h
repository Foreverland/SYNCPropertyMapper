@import CoreData;

static NSString * const HYPPropertyMapperCustomRemoteKey = @"hyper.remoteKey";

typedef NS_ENUM(NSInteger, HYPPropertyMapperRelationshipType) {
    HYPPropertyMapperRelationshipTypeNone = 0,
    HYPPropertyMapperRelationshipTypeArray,
    HYPPropertyMapperRelationshipTypeNested
};

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

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Could include relationships to other models.
 *  NSDate objects will be stringified to the ISO-8601 standard.
 * \param relationshipType - It indicates wheter the result dictionary should include no relationships, nested attributes or normal attributes
 * \return NSDictionary of values that can be serialized
 */
- (NSDictionary *)hyp_dictionaryUsingRelationshipType:(HYPPropertyMapperRelationshipType)relationshipType;

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Includes relationships to other models using Ruby on Rail's nested attributes model.
 * \param dateFormatter - A custom date formatter that turns NSDate objects into NSString objects. Do not pass nil, instead use the 'hyp_dictionary' method
 * \return NSDictionary of values that can be serialized
 */
- (NSDictionary *)hyp_dictionaryWithDateFormatter:(NSDateFormatter *)dateFormatter;

/*! Creates a NSDictionary of values based on the NSManagedObject subclass that can be serialized by NSJSONSerialization. Could include relationships to other models using Ruby on Rail's nested attributes model.
 * \param dateFormatter - A custom date formatter that turns NSDate objects into NSString objects. Do not pass nil, instead use the 'hyp_dictionary' method
 * \param relationshipType - It indicates wheter the result dictionary should include no relationships, nested attributes or normal attributes
 * \return NSDictionary of values that can be serialized
 */
- (NSDictionary *)hyp_dictionaryWithDateFormatter:(NSDateFormatter *)dateFormatter parent:(NSManagedObject *)parent usingRelationshipType:(HYPPropertyMapperRelationshipType)relationshipType;

- (NSDictionary *)hyp_dictionaryWithDateFormatter:(NSDateFormatter *)dateFormatter usingRelationshipType:(HYPPropertyMapperRelationshipType)relationshipType;

@end
