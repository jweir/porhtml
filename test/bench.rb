# typed: true

require './lib/html'
require 'benchmark/ips'
require 'sorbet-runtime'

T::Configuration.default_checked_level = :never

class Layout
  extend Html
  A = Html::Attribute

  def self.layout
    html(
      [],
      [title([A.title('Example')], []),
       meta([A.name('viewport'), A.content('width=device-width,initial-scale=1')], []),
       link([A.href('/assets/tailwind.css'), A.rel('stylesheet')], []),
       body([A.klass('bg-zinc-100')], yield)]
    )
  end
end

class HtmlBenchmark
  include Html
  A = Html::Attribute

  def template
    Layout.layout do
      [
        nav(
          [A.klass('p-5'), A.id('main_nav')],
          [ul(
            [],
            [li([A.klass('p-5')], [a([A.href('/')], [text('Home')])]),
             li([A.klass('p-5')], [a([A.href('/about')], [text('About')])]),
             li([A.klass('p-5')], [a([A.href('/contact')], [text('Contact')])])]
          )]
        ),
        h1([], [text('Hi')]),
        table([A.id('test')], [
                tr([],
                   if 1 > 2
                     [td([A.id('test1'), A.klass('a')], [span([], [text('Hi')])])]
                   else
                     [td([A.id('test2'), A.klass('a b')], [span([], [text('Hi')])]),
                      td([A.id('test3'), A.klass('a b c')], [span([], [text('Hi')])]),
                      td([A.id('test4'), A.klass('a b c d')], [span([], [text('Hi')])]),
                      td([A.id('test5'), A.klass('a b c d e')], [span([], [text('Hi')])])]
                   end)
              ])
      ]
    end
  end

  def to_html
    template.to_html
  end
end

Benchmark.ips do |x|
  x.report('Page', -> { HtmlBenchmark.new.to_html })
end
