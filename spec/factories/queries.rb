FactoryGirl.define do
  factory :query do
    sequence(:value) { |n| "Query ##{n}" }
  end
end
