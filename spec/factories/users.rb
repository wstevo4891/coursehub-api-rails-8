FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "testuser#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    is_admin { false }

    trait :admin do
      is_admin { true }
    end
  end
end
