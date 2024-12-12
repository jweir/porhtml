# typed: true

require_relative('../lib/fun_html')

a = FunHtml::Attribute.new

a.disabled true

b = FunHtml::Attribute.new do
  id('big')
  klass('a "b" c')
end

@template = FunHtml::Template.new

@template.html do
  head do
    title { text 'My Page Title' }
  end
  body do
    h1 { text 'Heading' }
    p { text 'This is a paragraph.' }
  end
end

class Template < FunHtml::Template
  extend T::Sig

  sig { returns(Template) }

  def test
    doctype
  end

  sig { params(items: T::Array[Item]).returns(Template) }
  def call(items)
    doctype
    html(attr do
           lang('en')
           max('en')
         end) do
      head do
        title { text 'Fun HTML' }
      end
      body do
        h1(attr { id('one') }) { text 'Title' }
        items.each do |item|
          div { a(attr { href(item.url) }) { text item.name } }
        end
      end
    end
  end
end

Item = Struct.new :name, :url

puts Template.new.call([Item.new('About', '/about'), Item.new('Home', '/')]).render
