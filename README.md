# Plain Old Ruby HTML

A simple Ruby HTML template engine. Its goals are to be 100% correct and
performant and secure and use only the standard library.

Example

```ruby
require_relative 'lib/html'

class Template < Html::Template
  def call(items)
    doctype
    html(attr { lang('en') }) do 
      head do 
        title { text "POR HTML" }
      end
      body do 
        h1(attr { id('one')}) { text "Title" }
        items.each do |item|
          div { a(attr { href(item.url) }) { text item.name }}
        end
      end
    end
  end
end

Item = Struct.new :name, :url 

puts Template.new.call([Item.new('About', '/about'), Item.new('Home', '/')]).render

```

Outside of some core code the library is statically generated from the W3C specification.

see https://github.com/w3c/webref for specification

## Notes

Originally this was typed via Sorbet, but performance was about 20% poorer.

## TODO

* Generate the attributes based on the available specs.  
* Attribute klass renamed to class 
* Define a recommend way to define layouts and templates
* Write class, method and example documentation.
* Publish a Gem

# Next
* Consider retuning Sorbet typing (possibily as an optional library, it affects performance)
* Support SVG

