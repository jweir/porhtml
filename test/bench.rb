# typed: true

require './lib/html'
require 'benchmark/ips'
# require 'sorbet-runtime'

# T::Configuration.default_checked_level = :never

class Layout < Html::Template
  A = Html::Attribute

  def call
    title(A.new { title('Example') }) {}
    meta(A.new do
           name('viewport')
           content('width=device-width,initial-scale=1')
         end) {}
    link(A.new do
           href('/assets/tailwind.css')
           rel('stylesheet')
         end) {}
    body(A.new { klass('bg-zinc-100') }) do
      nav(
        A.new do
          klass('p-5')
          id('main_nav')
        end
      ) do
        ul([]) do
          li(A.new { klass('p-5') }) { a(A.new { href('/') }) { text('Home') } }
          li(A.new { klass('p-5') }) { a(A.new { href('/about') }) { text('About') } }
          li(A.new { klass('p-5') }) { a(A.new { href('/contact') }) { text('Concat') } }
        end
      end

      h1([]) { text('Hi') }

      table(A.new { id('test') }) do
        tr([]) do
          td(A.new do
               id('test1')
               klass('a')
             end) { span([]) { text('Hi') } }
          td(A.new do
               id('test1')
               klass('a')
             end) { span([]) { text('Hi') } }
          td(A.new do
               id('test1')
               klass('a')
             end) { span([]) { text('Hi') } }
          td(A.new do
               id('test1')
               klass('a')
             end) { span([]) { text('Hi') } }
          td(A.new do
               id('test1')
               klass('a')
             end) { span([]) { text('Hi') } }
        end
      end
    end
  end
end

class HtmlBenchmark
  include Html
  A = Html::Attribute

  def template
    Layout.new.call.render
  end
end

Benchmark.ips do |x|
  x.report('Page', -> { HtmlBenchmark.new.template })
end
