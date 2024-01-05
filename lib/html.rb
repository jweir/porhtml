# typed: false

# require 'sorbet-runtime'
require './lib/html/node_definitions'
require './lib/html/attribute_definitions'
require 'erb/escape'

# nodoc
module Html
  # nodoc
  class Template
    def initialize
      @context = self
      @buffer = +''
    end

    include Html::NodeDefinitions

    # Given a proc instert the HTML into this template
    def insert(func)
      instance_exec(&func) if func
    end

    def text(value)
      @buffer << ERB::Escape.html_escape(value)
    end

    def render
      @buffer
    end

    private

    def write(open, close, attr = nil)
      @buffer << open << attr.to_s << '>'
      yield
      @buffer << close
      self
    end

    # TODO: write "void" elements
  end

  # nodoc
  class Attribute
    include ::ERB::Escape

    include Html::AttributeDefinitions

    def initialize(&block)
      @buffer = +''
      instance_eval(&block) # slower than yield self
    end

    def to_s
      @buffer
    end

    private

    def write(name, value)
      @buffer << name << html_escape(value) << '"'
    end
  end
end
