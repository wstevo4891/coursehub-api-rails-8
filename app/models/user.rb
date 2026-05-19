class User < ApplicationRecord
  # === Associations =======================================
  has_one :user_setting, class_name: "UserSetting"

  # === Validations ========================================
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end
