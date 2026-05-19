class UserSetting
  include Mongoid::Document
  include Mongoid::Timestamps

  # === Fields =============================================
  field :user_id, type: Integer

  field :theme, type: String, default: "light"

  field :language, type: String, default: "en"

  field :notifications, type: Hash, default: {}

  # === Associations =======================================
  # belongs_to :user, class_name: "User"
  def user
    User.find(self.user_id)
  end
end
