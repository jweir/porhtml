# typed: true

require 'sorbet-runtime'

# nodoc
module Html
  # nodoc
  class Element; end

  # nodoc
  class Node < Element
    def initialize(tag, attributes, elements)
      @tag = tag
      @attributes = attributes
      @elements = elements
      super()
    end

    def to_html
      "<#{@tag}>#{@elements.map(&:to_html).join}</#{@tag}>"
    end
  end

  # nodoc
  class Text < Element
    extend T::Sig

    sig { params(body: String).void }
    def initialize(body)
      # must be HTML escaped
      @body = body
      super()
    end

    def to_html
      @body
    end
  end

  def self.b(attributes, elements)
    Node.new(:b, attributes, elements)
  end

  def self.h1(attributes, elements)
    Node.new(:h1, attributes, elements)
  end

  def self.text(body)
    Text.new(body)
  end
end
