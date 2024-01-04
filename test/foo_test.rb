require 'minitest/autorun'

class FooTest < Minitest::Test
  class Foo
    def initialize(buffer)
      @buffer = buffer
    end

    def h1(attr, &)
      write(attr, 'h1', &)
    end

    def text(text)
      @buffer << text
    end

    private

    def write(_attr, tag, &)
      @buffer << '<' << tag << '>'
      instance_eval(&)
      @buffer << '</' << tag << '>'
    end
  end

  def test_foo
    el = Foo.new('')

    assert_equal(
      '<h1>ehllo goodbye<h1>now here</h1></h1>',
      el.h1([]) do
        text 'ehllo'
        text ' '
        text 'goodbye'
        h1([]) { text 'now here' }
      end
    )
  end
end
