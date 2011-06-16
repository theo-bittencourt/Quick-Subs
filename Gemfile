source 'http://rubygems.org'

gem 'rails', '3.1.0.rc1'
gem 'mechanize'
gem 'rubyzip'
gem 'unicode_utils'

group :production do
  gem 'therubyracer-heroku', '0.8.1.pre3'
  gem 'pg'
end

group :development, :test do
  gem 'mongrel', '>=1.2.0.pre2'
  gem 'sqlite3'
  gem 'ruby-debug19'
end

# Asset template engines
gem 'sass'
gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

