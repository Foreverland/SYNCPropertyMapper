# NSManagedObject-HYPPropertyMapper
[![Build Status](https://img.shields.io/travis/hyperoslo/NSManagedObject-HYPPropertyMapper.svg?style=flat)](https://travis-ci.org/hyperoslo/NSManagedObject-HYPPropertyMapper)

Mapping your Core Data objects with your JSON providing backend has never been this easy. 
If you don't already use this, you should; and here is why:

Getting a dictionary representation of your object is as easy as pie.

``` objc
UserManagedObject *user;
[user setValue:@"John" forKey:@"firstName"];
[user setValue:@"Hyperseed" forKey:@"lastName"];

NSDictionary *userValues = [user hyp_dictionary];
```

That's it, that's all you have to do.
But that's not all, the keys will be magically transformed into a lowercase/underscore convention.

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

----------------

But wait, there is more. What if you get values from your JSON providing backend and want those values on your object?

We got you covered:

``` objc
NSDictionary *values = [JSON valueForKey:@"user"];
[user hyp_fillWithDictionary:values];
```

Boom, it's just that easy.

And what about if you want to map a key that it's in the JSON into your core data, but your attribute has a different name? It's as easy as typing: `hyper.remoteKey` in the user attributes with the value you want to map.

![Remote mapping documentation](url)

And then what? Nothing, job done!

Now I have a question... Why are you not using this already?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

[Hyper](http://hyper.no) made this. We're a digital communications agency with a passion for good code,
and if you're using this library we probably want to hire you.

## License

NSManagedObject-HYPPropertyMapper is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hyperoslo/NSManagedObject-HYPPropertyMapper/master/LICENSE.md) file for more info.
