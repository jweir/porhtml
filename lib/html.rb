# frozen_string_literal: true

require './lib/html/node_definitions'
require './lib/html/attribute_definitions'
require 'erb/escape'

# nodoc
module Html
  # nodoc
  class Writer
    def initialize
      @__buffer = +''
    end

    def include(func)
      begin
        @__buffer << func.render
      rescue StandardError
        instance_exec(&func)
      end
      self
    end

    def text(value)
      @__buffer << ERB::Escape.html_escape(value)
      self
    end

    def attr(&block)
      Attribute.new(&block)
    end

    def comment(&elements)
      write('<!--', '-->', nil, closing_char: '', closing_void_char: '-->', &elements)
    end

    def doctype
      @__buffer << '<!DOCTYPE html>'
      self
    end

    def render
      @__buffer
    end

    private

    CLOSE = '>'
    CLOSE_VOID = '/>'

    def write(open, close, attr = nil, closing_char: CLOSE, closing_void_char: CLOSE_VOID, &block)
      @__buffer << open << Attribute.to_html(attr)

      if block
        @__buffer << closing_char

        begin
          yield
        # this is faster, at least in the default than using an if and checking
        # the type on the receiver
        rescue StandardError
          instance_eval(&block)
        end
        @__buffer << close
      else
        @__buffer << closing_void_char
      end

      self
    end
  end

  # nodoc
  class Template < Html::Writer
    include Html::NodeDefinitions::HTMLAllElements
  end

  # nodoc
  class Attribute
    include Html::AttributeDefinitions

    # only allow nil or objects that respond to `safe_attribute`
    def self.to_html(attr)
      attr&.safe_attribute.to_s
    end

    def initialize(buffer = +'', &block)
      @__buffer = buffer
      instance_eval(&block) if block
    end

    def <<(other)
      self.class.new(@__buffer.dup << other.safe_attribute.dup)
    end

    def safe_attribute
      @__buffer
    end

    private

    QUOTE = '"'

    def write(name, value)
      @__buffer << name << ERB::Escape.html_escape(value) << QUOTE
    end
  end
end
