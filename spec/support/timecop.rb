RSpec.configure do |config|
  config.before(:suite) do
    Timecop.safe_mode = true
  end
end
