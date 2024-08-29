# frozen_string_literal: true

require './lib/fun_html'
require 'benchmark/ips'

class Layout < FunHtml::Template
  A = FunHtml::Attribute

  def call
    title(attr { title('Example') })
    meta(attr do
      name('viewport')
      content('width=device-width,initial-scale=1')
    end)
    link(attr do
      href('/assets/tailwind.css')
      rel('stylesheet')
    end)
    body(attr { klass('bg-zinc-100') }) do
      nav(
        attr do
          klass('p-5')
          id('main_nav')
        end
      ) do
        attr = A.new
        attr.klass 'p-5'

        ul do
          li(attr) { a(attr { href('/') }) { text('Home') } }
          li(attr) { a(attr { href('/about') }) { text('About') } }
          li(attr) { a(attr { href('/contact') }) { text('Concat') } }
        end
      end

      h1 { text('Hi') }

      attr = A.new
      attr.id('test1')
      attr.id('a')

      table(A.new { id('test') }) do
        tr do
          td(attr) { span { text('Hi') } }
          td(attr) { span { text('Hi') } }
          td(attr) { span { text('Hi') } }
          td(attr) { span { text('Hi') } }
          td(attr) { span { text('Hi') } }
        end
      end
    end
  end
end

class HtmlBenchmark
  include FunHtml
  A = FunHtml::Attribute

  def template
    Layout.new.call.render
  end
end

Benchmark.ips do |x|
  x.report('Page', -> { HtmlBenchmark.new.template })
end
