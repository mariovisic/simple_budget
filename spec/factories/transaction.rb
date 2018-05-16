FactoryGirl.define do
  factory :transaction do
    name 'My transaction'
    purchased_at { Time.now }
  end
end
