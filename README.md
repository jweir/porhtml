# Ruby HTML

This is a type safe (via Sorbet) HTML library using plain Ruby.

There are no dependencies beyond the Ruby standard library.

Its goals are to be 100% correct and performant and secure.

Example

```ruby

Html.h1(
  [Attribute.style("width","100%")],
  [
    Html.b(
      [], 
      [Html.text('Hello!')]
    )
  ])
```

Outside of some core code the library is statically generated from the W3C specification.

see https://github.com/w3c/webref for specification

## Security
Can the Sorbet type system provide the necessary security?
Will Loofah be needed or some other sanitizer?
