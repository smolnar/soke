FactoryGirl.define do
  factory :search do
    association :query
    association :session
    association :user

    trait :annotated do
      annotated_at { Time.now }
    end
  end
end
