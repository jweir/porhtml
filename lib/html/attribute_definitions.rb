# frozen_string_literal: true
# typed: false

module Html
  # nodoc
  module AttributeDefinitions
    # extend T::Sig

    def id(value)
      write(' id="', value)
    end

    # FIXME: need to auto map `class` to `klass`
    def klass(value)
      write(' class="', value)
    end

    def href(value)
      write(' href="', value)
    end

    def rel(value)
      write(' rel="', value)
    end

    def content(value)
      write(' content="', value)
    end

    def name(value)
      write(' name="', value)
    end

    def title(value)
      write(' title="', value)
    end
  end
end
