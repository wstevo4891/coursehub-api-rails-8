FactoryBot.define do
  factory :refresh_token do
    user { nil }
    token { "MyString" }
    expires_at { "2026-05-20 12:43:32" }
  end
end
