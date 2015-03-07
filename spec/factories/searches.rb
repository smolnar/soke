FactoryGirl.define do
  factory :search do
    association :query
    association :session
    association :user
  end
end
