source 'https://rubygems.org'

ruby '2.3.3'

gem 'rails', '4.2.5.1'
gem 'pg'
gem 'simple_form'
gem 'bcrypt'
gem 'puma'

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'web-console'
  gem 'spring'
  gem 'dotenv' # heroku handles this in production
end

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'timecop'
  gem 'factory_girl_rails'
end
