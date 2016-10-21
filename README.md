![Sync](https://raw.githubusercontent.com/SyncDB/SYNCPropertyMapper/master/GitHub/logo-v2.png)

**SYNCPropertyMapper** leverages on your Core Data model to infer how to map your JSON values into Core Data. It's simple and it's obvious. Why the hell isn't everybody doing this?

# Table of Contents

* [Filling a NSManagedObject with JSON](#filling-a-nsmanagedobject-with-json)
  * [JSON in CamelCase](#json-in-camelcase)
  * [JSON in snake_case](#json-in-snake_case)
  * [Exceptions](#exceptions)
  * [Custom](#custom)
  * [Deep mapping](#deep-mapping)
  * [Attribute Types](#attribute-types)
    * [Date](#date)
    * [Array](#array)
    * [Dictionary](#dictionary)
  * [Value Transformations](#value-transformations)
* [JSON representation from a NSManagedObject](#json-representation-from-a-nsmanagedobject)
  * [Excluding](#excluding)
  * [Relationships](#relationships)
* [Installation](#installation)
* [Contributing](#contributing)
* [Credits](#credits)
* [License](#license)

# Filling a NSManagedObject with JSON

Mapping your Core Data objects with your JSON providing backend has never been this easy.

## JSON in CamelCase

```json
{
  "firstName": "John",
  "lastName": "Hyperseed"
}
```

``` objc
NSDictionary *values = [JSON valueForKey:@"user"];
[user hyp_fillWithDictionary:values];
```

Your Core Data entities should match your backend models. Your attributes should match their JSON counterparts. For example `firstName` maps to `firstName`, `address` to `address`.

## JSON in snake_case

```json
{
  "first_name": "John",
  "last_name": "Hyperseed"
}
```

``` objc
NSDictionary *values = [JSON valueForKey:@"user"];
[user hyp_fillWithDictionary:values];
```

Your Core Data entities should match your backend models but in `camelCase`. Your attributes should match their JSON counterparts. For example `first_name` maps to `firstName`, `address` to `address`.

## Exceptions

There are two exceptions to this rules:

* `id`s should match `remoteID`
* Reserved attributes should be prefixed with the `entityName` (`type` becomes `userType`, `description` becomes `userDescription` and so on). In the JSON they don't need to change, you can keep `type` and `description` for example. A full list of reserved attributes can be found [here](https://github.com/SyncDB/SYNCPropertyMapper/blob/master/Sources/NSManagedObject%2BSYNCPropertyMapper/NSManagedObject%2BSYNCPropertyMapperHelpers.m#L240).

## Custom

![Remote mapping documentation](https://raw.githubusercontent.com/SyncDB/SYNCPropertyMapper/master/Resources/userInfo_documentation.png)

* If you want to map your Core Data identifier (key) attribute with a JSON attribute that has different naming, you can do by adding `hyper.remoteKey` in the user info box with the value you want to map.

## Deep mapping

```json
{
  "id": 1,
  "name": "John Monad",
  "company": {
    "name": "IKEA"
  }
}
```

In this example, if you want to avoid creating a Core Data entity for the company, you could map straight to the company's name. By adding this to the *User Info* of your `companyName` field:

```
hyper.remoteKey = company.name
```

## Attribute Types

For mapping for arrays and dictionaries just set attributes as `Binary Data` on the Core Data modeler

![screen shot 2015-04-02 at 11 10 11 pm](https://cloud.githubusercontent.com/assets/1088217/6973785/7d3767dc-d98d-11e4-8add-9c9421b5ed47.png)

### Date

We went for supporting [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601) and unix timestamp out of the box because those are the most common formats when parsing dates, also we have a [quite performant way to parse this strings](https://github.com/3lvis/DateParser) which overcomes the [performance issues of using `NSDateFormatter`](http://blog.soff.es/how-to-drastically-improve-your-app-with-an-afternoon-and-instruments/).

```objc
NSDictionary *values = @{@"created_at" : @"2014-01-01T00:00:00+00:00",
                         @"updated_at" : @"2014-01-02",
                         @"published_at": @"1441843200"
                         @"number_of_attendes": @20};

[managedObject hyp_fillWithDictionary:values];

NSDate *createdAt = [managedObject valueForKey:@"createdAt"];
// ==> "2014-01-01 00:00:00 +00:00"

NSDate *updatedAt = [managedObject valueForKey:@"updatedAt"];
// ==> "2014-01-02 00:00:00 +00:00"

NSDate *publishedAt = [managedObject valueForKey:@"publishedAt"];
// ==> "2015-09-10 00:00:00 +00:00"
```

If your date is not [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601) compliant, you can use a transformer attribute to parse your date, too. First set your attribute to `Transformable`, and set the name of your transformer like, in this example is `DateStringTransformer`:

![transformable-attribute](https://raw.githubusercontent.com/SyncDB/SYNCPropertyMapper/master/Resources/date-transformable.png)

You can find an example of date transformer in [DateStringTransformer](https://github.com/SyncDB/SYNCPropertyMapper/blob/master/Tests/NSManagedObject%2BSYNCPropertyMapper/Transformers/DateStringTransformer.m).

### Array
```objc
NSDictionary *values = @{@"hobbies" : @[@"football",
                                        @"soccer",
                                        @"code"]};

[managedObject hyp_fillWithDictionary:values];

NSArray *hobbies = [NSKeyedUnarchiver unarchiveObjectWithData:managedObject.hobbies];
// ==> "football", "soccer", "code"
```

### Dictionary
```objc
NSDictionary *values = @{@"expenses" : @{@"cake" : @12.50,
                                         @"juice" : @0.50}};

[managedObject hyp_fillWithDictionary:values];

NSDictionary *expenses = [NSKeyedUnarchiver unarchiveObjectWithData:managedObject.expenses];
// ==> "cake" : 12.50, "juice" : 0.50
```

## Value Transformations

Sometimes values in a REST API are not formatted in the way you want them, resulting in you having to extend your model classes with methods and/or properties for transformed values.

For example, what if I want to encode this title before setting it to my model?

```json
{
  "title": "Foo &#038; bar"
}
```

This requires your client to handle HTML entitles each time you need `title`, or using transformable attributes which would make your `title` a NSData.

Welp, not anymore!

First, open your Core Data model and the name of your transformer to `hyper.valueTransformer`. For this example we'll use `HYPTitleEncodingValueTransformer`.

```objc
#import "HYPTitleEncodingValueTransformer.h"

@implementation HYPTitleEncodingValueTransformer

+ (Class)transformedValueClass {
    return [NSString class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;

    NSString *stringValue = nil;

    if ([value isKindOfClass:[NSString class]]) {
        stringValue = (NSString *)value;
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Value (%@) is not of type NSString.", [value class]];
    }

    return [stringValue stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}

- (id)reverseTransformedValue:(id)value {
    if (value == nil) return nil;

    NSString *stringValue = nil;

    if ([value isKindOfClass:[NSString class]]) {
        stringValue = (NSString *)value;
    } else {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Value (%@) is not of type NSString.", [value class]];
    }

    return [stringValue stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
}

@end
```

Then before `hyp_fillWithDictionary` we'll do

```objc
[NSValueTransformer setValueTransformer:[[HYPTitleEncodingValueTransformer alloc] init] forName:@"HYPTitleEncodingValueTransformer"];
```

That's it! Then your title will be `"Foo & bar"`.

It works the other way as well! So using `hyp_dictionary` will return `"Foo &#038; bar"`

# JSON representation from a NSManagedObject

``` objc
UserManagedObject *user;
[user setValue:@"John" forKey:@"firstName"];
[user setValue:@"Hyperseed" forKey:@"lastName"];

NSDictionary *userValues = [user hyp_dictionary];
```

That's it, that's all you have to do, the keys will be magically transformed into a `snake_case` convention.

```json
{
  "first_name": "John",
  "last_name": "Hyperseed"
}
```

## Excluding

If you don't want to export attribute / relationship, you can prohibit exporting by adding `hyper.nonExportable` in the user info of the excluded attribute.

// TODO: Include photo of user key.

## Relationships

It supports relationships too, and we complain to the Rails rule `accepts_nested_attributes_for`, for example for a user that has many notes:

```json
"first_name": "John",
"last_name": "Hyperseed",
"notes_attributes": [
  {
    "0": {
      "id": 0,
      "text": "This is the text for the note A"
    },
    "1": {
      "id": 1,
      "text": "This is the text for the note B"
    }
  }
]
```

If you don't want to get nested relationships you can also ignore relationships:

```objc
NSDictionary *dictionary = [user hyp_dictionaryUsingRelationshipType:SYNCPropertyMapperRelationshipTypeNone];
```

```json
"first_name": "John",
"last_name": "Hyperseed"
```

Or get them as an array:

```objc
NSDictionary *dictionary = [user hyp_dictionaryUsingRelationshipType:SYNCPropertyMapperRelationshipTypeArray];
```
```json
"first_name": "John",
"last_name": "Hyperseed",
"notes": [
  {
    "id": 0,
    "text": "This is the text for the note A"
  },
  {
    "id": 1,
    "text": "This is the text for the note B"
  }
]
```

## Installation

**SYNCPropertyMapper** is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'SYNCPropertyMapper'
```

## Contributing

Please Hyper's [playbook](https://github.com/hyperoslo/playbook/blob/master/GIT_AND_GITHUB.md) for guidelines on contributing.

## Credits

[Hyper](http://hyper.no) made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to [hire you](http://www.hyper.no/jobs/ios-developer).

## License

SYNCPropertyMapper is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/SyncDB/SYNCPropertyMapper/master/LICENSE.md) file for more info.
