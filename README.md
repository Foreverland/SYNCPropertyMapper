NSManagedObject-HYPPropertyMapper
===============

Mapping your Core Data objects with your Ruby backend has never been this easy. 
If you don't already use this, you should; and here is why:

Getting a dictionary representation of your object is as easy as pie.

``` objc
NSDictionary *values = [randomAwesomeObject hyp_dictionary];
```

That's it, that's all you have to do.
But that's not all, the keys will be magically transformed into a lowercase/underscore convention that conforms to the Ruby standard.

Example: firstName will be transformed into first_name.

But wait, there is more.
What if you get values from the Ruby backend and want those values on your object?
We got you covered:

``` objc
[randomAwesomeObject hyp_fillWithDictionary:shineyNewValuesFromBackend];
```

Boom, it's just that easy. My question to you is, why are you not using this already?

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

NSManagedObject-HYPPropertyMapper is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hyperoslo/NSManagedObject-HYPPropertyMapper/develop/LICENSE.md) file for more info.
