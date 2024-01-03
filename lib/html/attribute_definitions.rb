# frozen_string_literal: true
# typed: strict

module Html
  # nodoc
  module AttributeDefinitions
    extend T::Sig

    sig { params(value: String).returns(Attribute) }
    def id(value)
      Attribute.new('id', value)
    end

    # FIXME: need to auto map `class` to `klass`
    sig { params(value: String).returns(Attribute) }
    def klass(value)
      Attribute.new('class', value)
    end

    sig { params(value: String).returns(Attribute) }
    def href(value)
      Attribute.new('href', value)
    end

    sig { params(value: String).returns(Attribute) }
    def rel(value)
      Attribute.new('rel', value)
    end

    sig { params(value: String).returns(Attribute) }
    def content(value)
      Attribute.new('content', value)
    end

    sig { params(value: String).returns(Attribute) }
    def name(value)
      Attribute.new('name', value)
    end

    sig { params(value: String).returns(Attribute) }
    def title(value)
      Attribute.new('title', value)
    end
  end
end
