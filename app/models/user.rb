class User < ApplicationRecord
  # === Attributes =========================================
  has_secure_password

  # === Associations =======================================
  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :refresh_tokens, dependent: :destroy

  # has_one :user_setting, class_name: "UserSetting"
  def user_setting
    UserSetting.where(user_id: self.id).first
  end

  def user_setting=(settings)
    UserSetting.create!(user_id: self.id, **settings)
  end

  # === Validations ========================================
  validates :name, presence: true

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :password, length: { minimum: 6 },
                       if: -> { new_record? || !password.nil? }

  # === Instance Methods ===================================
  def admin_status
    is_admin ? "Administrator" : "User"
  end
end
