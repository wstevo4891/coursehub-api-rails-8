FactoryBot.define do
  factory :user_setting do
    user
    theme { "light" }
    language { "en" }
    notifications { { email: true, sms: false } }
  end
end
