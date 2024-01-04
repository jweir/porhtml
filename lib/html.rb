# typed: strict

require 'debug'
require 'sorbet-runtime'
require './lib/html/node_definitions'
require './lib/html/attribute_definitions'
require 'erb/escape'

# nodoc
module Html
  extend T::Sig

  # nodoc
  class Template
    def initialize(buffer)
      @buffer = buffer
    end

    include Html::NodeDefinitions

    def text(value)
      @buffer << ERB::Escape.html_escape(value)
    end

    private

    def write(tag, attr, &)
      lattr = ''
      attr.each { lattr << _1.to_attr } if attr.any?
      @buffer << '<' << tag << lattr << '>'
      instance_eval(&)
      @buffer << '</' << tag << '>'
    end
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
end
