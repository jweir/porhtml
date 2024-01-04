# typed: true

require './lib/html'
require 'benchmark/ips'
require 'sorbet-runtime'

T::Configuration.default_checked_level = :never

class Layout
  A = Html::Attribute

  def self.layout(&block)
    Html::Template.new('').html([]) do
      title([A.title('Example')]) {}
      meta([A.name('viewport'), A.content('width=device-width,initial-scale=1')]) {}
      link([A.href('/assets/tailwind.css'), A.rel('stylesheet')]) {}
      body([A.klass('bg-zinc-100')], &block)
    end
  end
end

class HtmlBenchmark
  include Html
  A = Html::Attribute

  def template
    Layout.layout do
      nav(
        [A.klass('p-5'), A.id('main_nav')]
      ) do
        ul([]) do
          li([A.klass('p-5')]) { a([A.href('/')]) { text('Home') } }
          li([A.klass('p-5')]) { a([A.href('/about')]) { text('About') } }
          li([A.klass('p-5')]) { a([A.href('/contact')]) { text('Concat') } }
        end
      end

      h1([]) { text('Hi') }

      table([A.id('test')]) do
        tr([]) do
          td([A.id('test1'), A.klass('a')]) { span([]) { text('Hi') } }
          td([A.id('test1'), A.klass('a')]) { span([]) { text('Hi') } }
          td([A.id('test1'), A.klass('a')]) { span([]) { text('Hi') } }
          td([A.id('test1'), A.klass('a')]) { span([]) { text('Hi') } }
          td([A.id('test1'), A.klass('a')]) { span([]) { text('Hi') } }
        end
      end
    end
  end
end

Benchmark.ips do |x|
  x.report('Page', -> { HtmlBenchmark.new.template })
end
