default:
	find . -name "*.rb" | entr ruby test/html_test.rb

bench:
	find . -name "*.rb" | entr ruby test/bench.rb

update:
	bin/tapioca annotations
	bin/tapioca gem --all
	bundle exec tapioca dsl
	bin/tapioca todo

generate:
	ruby -r ./lib/html/generator.rb -e 'Html::Generator.call'
	rubocop -A lib/html/node_definitions.rb
