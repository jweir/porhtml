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

    def write(open, close, attr = nil, &block)
      if block
        @buffer << open << attr.to_s << '>'
        yield
        @buffer << close
      else
        @buffer << open << attr.to_s << '/>'
      end
      self
    end
  end

  # nodoc
  class Attribute
    include Html::AttributeDefinitions

    def initialize(buffer = +'', &block)
      @buffer = buffer
      instance_eval(&block) if block
    end

    def <<(other)
      self.class.new(@buffer.dup << other.to_s.dup)
    end

    def to_s
      @buffer
    end

    def write(name, value)
      @buffer << name << ERB::Escape.html_escape(value) << '"'
    end

    private

    attr_reader :buffer
  end
end
