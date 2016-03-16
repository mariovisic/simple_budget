require 'timecop'

RSpec.configure do |config|
  config.before(:suite) do
    Timecop.safe_mode = true
  end

  config.around(:each, timecop: true) do |example|
    Timecop.freeze(example.metadata[:timecop]) do
      example.run
    end
  end
end
