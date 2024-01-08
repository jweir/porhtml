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

    END_TAG = '>'.freeze
    CLOSE = '/>'.freeze

    def write(open, close, attr = nil, &block)
      @buffer << open << Attribute.to_html(attr)
      if block
        @buffer << END_TAG

        begin
          yield
        # this is faster, at least in the default than using an if and checking
        # the type on the receiver
        rescue StandardError
          instance_eval(&block)
        end
        @buffer << close
      else
        @buffer << CLOSE
      end
      self
    end
  end

  # nodoc
  class Attribute
    include Html::AttributeDefinitions

    # only allow nil or objects that respond to `safe_attribute`
    def self.to_html(attr)
      attr&.safe_attribute.to_s
    end

    def initialize(buffer = +'', &block)
      @buffer = buffer
      instance_eval(&block) if block
    end

    def <<(other)
      self.class.new(@buffer.dup << other.safe_attribute.dup)
    end

    QUOTE = '"'.freeze

    def write(name, value)
      @buffer << name << ERB::Escape.html_escape(value) << QUOTE
    end

    def safe_attribute
      @buffer
    end

    private

    attr_reader :buffer
  end
end
