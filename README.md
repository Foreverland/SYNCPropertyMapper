# Filling a NSManagedObject with JSON

Mapping your Core Data objects with your JSON providing backend has never been this easy. 

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

There are two exceptions to this rule:

* `id`s should match `remoteID`
* Reserved attributes should be prefixed with the `entityName` (`type` becomes `userType`, `description` becomes `userDescription` and so on). In the JSON they don't need to change, you can keep `type` and `description` for example. A full list of reserved attributes can be found [here](https://github.com/hyperoslo/NSManagedObject-HYPPropertyMapper/blob/master/Source/NSManagedObject%2BHYPPropertyMapper.m#L265)

If you want to map your Core Data attribute with a JSON attribute that has different naming, you can do by adding `hyper.remoteKey` in the user info box with the value you want to map.

![Remote mapping documentation](https://raw.githubusercontent.com/hyperoslo/NSManagedObject-HYPPropertyMapper/master/Resources/userInfo_documentation.png)

## Attribute Types

For mapping for arrays and dictionaries just set attributes as `Binary Data` on the Core Data modeler

![screen shot 2015-04-02 at 11 10 11 pm](https://cloud.githubusercontent.com/assets/1088217/6973785/7d3767dc-d98d-11e4-8add-9c9421b5ed47.png)

### Dates

We went for just supporting [ISO8601](http://en.wikipedia.org/wiki/ISO_8601) out of the box because that's the most common format when parsing dates, also we have a [quite performant way to parse this strings](https://github.com/hyperoslo/NSManagedObject-HYPPropertyMapper/blob/master/Source/NSManagedObject%2BHYPPropertyMapper.m#L272-L319) which overcomes the [performance issues of using `NSDateFormatter`](http://blog.soff.es/how-to-drastically-improve-your-app-with-an-afternoon-and-instruments/).

```objc
NSDictionary *values = @{@"created_at" : @"2014-01-01T00:00:00+00:00",
                         @"updated_at" : @"2014-01-02",
                         @"number_of_attendes": @20};

[managedObject hyp_fillWithDictionary:values];

NSDate *createdAt = [managedObject valueForKey:@"createdAt"];
// ==> "2014-01-01 00:00:00 +00:00" 

NSDate *updatedAt = [managedObject valueForKey:@"updatedAt"];
// ==> "2014-01-02 00:00:00 +00:00" 
```

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

### Installation

**NSManagedObject-HYPPropertyMapper** is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'NSManagedObject-HYPPropertyMapper'
```

## Contributing

Please check our [playbook](https://github.com/hyperoslo/playbook/blob/master/GIT_AND_GITHUB.md) for guidelines on contributing.

## Credits

[Hyper](http://hyper.no) made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to [hire you](http://www.hyper.no/jobs/ios-developer).

## License

NSManagedObject-HYPPropertyMapper is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hyperoslo/NSManagedObject-HYPPropertyMapper/master/LICENSE.md) file for more info.
