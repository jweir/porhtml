default:
	find . -name "*.rb" | entr ruby test/html_test.rb

update:
	bundle exec tapioca annotations
	bundle exec tapioca dsl
	bundle exec tapioca gem
	bundle exec tapioca todo

