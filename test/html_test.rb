# xtyped: true

require './lib/html'
require 'minitest/autorun'

class HtmlTest < Minitest::Test
  class HTEX
    include Html
  end

  HT = HTEX.new
  A = Html::Attribute
  def test_to_html
    x = HT.h1([],
              [HT.b([],
                    [HT.text('Hello')])])
    assert_equal '<h1><b>Hello</b></h1>', x.to_html
  end

  def test_attributes
    # TODO: allow things like &nbsp;? I don't think so
    # FIXME sanitize quotes?
    x = HT.h1([A.id('big'), A.klass('a "b" c')],
              [HT.b([],
                    [HT.text('Hello & good "byte"')])])
    assert_equal '<h1 id="big" class="a &quot;b&quot; c"><b>Hello &amp; good &quot;byte&quot;</b></h1>', x.to_html
  end

  def test_text_html_is_escaped
    assert_equal '&lt;script&gt;x&lt;/script&gt;', HT.text('<script>x</script>').to_html
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
