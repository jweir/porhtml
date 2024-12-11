default:
	find . -name "*.rb" | entr bundle exec rake

bench:
	find . -name "*.rb" | entr ruby test/bench.rb

update:
	bin/tapioca annotations
	bin/tapioca gem --all
	bundle exec tapioca dsl
	bin/tapioca todo

generate:
	ruby -r ./lib/fun_html/generator.rb -e 'FunHtml::Generator.call'
	rubocop -A lib/fun_html/node_definitions.rb

attr:
	ruby -r ./lib/fun_html/attribute_generator.rb -e 'FunHtml::AttributeGenerator.call'
	rubocop -A lib/fun_html/attribute_definitions.rb
