# xtyped: true

require './lib/html'
require 'minitest/autorun'

class HtmlTest < Minitest::Test
  A = Html::Attribute
  def test_to_html
    t = Html::Template.new ''
    x = t.h1([]) do
      b([]) { text 'Hello' }
    end
    assert_equal '<h1><b>Hello</b></h1>', x
  end

  def test_attributes
    t = Html::Template.new ''
    # TODO: allow things like &nbsp;? I don't think so
    # FIXME sanitize quotes?
    x = t.h1([A.id('big'), A.klass('a "b" c')]) do
      b([]) { text('Hello & good "byte"') }
    end

    assert_equal '<h1 id="big" class="a &quot;b&quot; c"><b>Hello &amp; good &quot;byte&quot;</b></h1>', x
  end

  def test_text_html_is_escaped
    t = Html::Template.new ''
    assert_equal '&lt;script&gt;x&lt;/script&gt;', t.text('<script>x</script>')
  end

  # TODO
  # defines all attributes with type
  # join class and style types
end

# style
# property
# attribute
# class
# id
# title
# hidden
# type
# value
# checked
# disabled
# placeholder
# selected
# -- input
# accept
# acceptCharset
# action
# autocomplete
# autofocus
# disabled
# enctype
# list
# maxlength
# minlength
# multiple
# name
# novalidate
# pattern
# readonly
# required
# size
# for
# form
#
#
#
#
#
#
