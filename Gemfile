source 'https://rubygems.org'

ruby '2.7.4'

gem 'rails', '~> 5.2'
gem 'pg', '~> 0.15'
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
  gem "rspec-buildkite-analytics", path: "/Users/mario.visic/Code/buildkite/rspec-buildkite-analytics"
end
