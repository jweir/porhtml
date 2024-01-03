# typed: strict

require 'sorbet-runtime'
require './lib/html/node_definitions'
require './lib/html/attribute_definitions'
require 'erb/escape'

# nodoc
module Html
  extend T::Sig

  # nodoc
  class Element
    extend T::Sig

    sig { returns(String) }
    def to_html = ''
  end

  # nodoc
  class Attribute
    extend T::Sig
    include ::ERB::Escape

    sig { params(name: String, value: String).void }
    def initialize(name, value)
      @name = name
      @value = value
    end

    sig { returns(String) }
    def to_attr
      " #{@name}=\"#{html_escape(@value)}\""
    end

    extend Html::AttributeDefinitions
  end

  # nodoc
  class Node < Element
    extend T::Sig

    sig { params(tag: String, attributes: T::Array[Attribute], elements: T::Array[Element]).void }
    def initialize(tag, attributes, elements)
      @tag = tag
      @attributes = attributes
      @elements = elements
    end

    sig { returns(String) }
    def to_html
      if @attributes.any?
        attr = ''
        @attributes.each { attr << _1.to_attr }
        local_acc = "<#{@tag}#{attr}>"
      else
        local_acc = "<#{@tag}>"
      end
      @elements.each { local_acc << _1.to_html }
      local_acc << "</#{@tag}>"
    end
  end

  # nodoc
  class Text < Element
    extend T::Sig
    include ERB::Escape

    sig { params(body: String).void }
    def initialize(body)
      @body = body
    end

    # FIXME: must be HTML escaped
    sig { returns(String) }
    def to_html
      html_escape(@body)
    end
  end

  sig { params(body: String).returns(Html::Text) }
  def text(body)
    Text.new(body)
  end

  include Html::NodeDefinitions
end
