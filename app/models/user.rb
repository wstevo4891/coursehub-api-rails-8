class User < ApplicationRecord
  # === Associations =======================================
  has_many :enrollments
  has_many :courses, through: :enrollments

  # has_one :user_setting, class_name: "UserSetting"
  def user_setting
    UserSetting.where(user_id: self.id).first
  end

  def user_setting=(settings)
    UserSetting.create!(user_id: self.id, **settings)
  end

  # === Validations ========================================
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end
