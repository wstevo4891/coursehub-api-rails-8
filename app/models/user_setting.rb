class UserSetting
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields =============================================
  field :theme, type: String, default: "light"

  field :language, type: String, default: "en"

  field :notifications, type: Hash, default: {}

  # === Associations =======================================
  belongs_to :user, class_name: "User"
end
