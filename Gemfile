source 'https://rubygems.org'

# Force git gems to use secure HTTPS
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7', '>= 6.1.7.5'
gem 'mysql2', '~> 0.5.0'
gem 'bootsnap'
gem 'rails-controller-testing'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
gem 'launchy'
# Use jquery as the JavaScript library
gem 'jquery-rails', '>= 4.5.0'
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc
gem 'puma'
gem 'active_model_serializers', '>= 0.10.14'
gem 'bootstrap-sass'
gem 'font-awesome-rails', '>= 4.7.0.8'
gem 'net-ldap'
gem 'kaminari', '>= 1.2.2'
gem 'exception_notification', '>= 4.5.0'
gem 'ejs', '~> 1.1', '>= 1.1.1'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use Unicorn as the app server
# gem 'unicorn'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

###
# Sanger gems
###
gem 'pmb-client', '0.1.0', :github => 'sanger/pmb-client'


###
# Groups
###
group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 4.2.0'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver', '<= 4.9.0', require: false
  gem 'database_cleaner', '>= 2.0.2'
  gem 'rake'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'factory_bot_rails', '>= 6.2.0'
  gem 'rspec-rails', '>= 5.0.2'
  gem 'with_model', '>= 2.1.6'
  gem 'raml_ruby'
  gem 'listen'
end

group :deployment do
  gem 'therubyracer'
end
