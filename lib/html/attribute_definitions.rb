# frozen_string_literal: true

module Html
  # nodoc
  module AttributeDefinitions
    def id(value)
      write(' id="', value)
    end

    def lang(value)
      write(' lang="', value)
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

    def src(value)
      write(' src="', value)
    end

    def alt(value)
      write(' alt="', value)
    end
  end
end
