# typed: strict

require 'minitest/autorun'
require './lib/html'

class HtmlTest < Minitest::Spec
  specify 'sample produces the expected HTML' do
    x = Html.h1([],
                [Html.b([],
                        [Html.text('Hello')])])
    assert_equal '<h1><b>Hello</b></h1>', x.to_html
  end

  specify 'html is escaped' do
    flunk
  end

  specify 'incorrect types fail' do
    m = assert_raises do
      Html::Text.new([1, 2, 3])
    end

    assert_equal TypeError, m.class
  end
end
