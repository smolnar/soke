FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "johnny#{n}@example.com" }

    password 'password123'
  end
end
