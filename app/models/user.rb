class User < ApplicationRecord
  # === Attributes =========================================
  has_secure_password

  # === Associations =======================================
  has_many :enrollments
  has_many :courses, through: :enrollments
  has_many :refresh_tokens, dependent: :destroy

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

  def user_setting
    @user_setting ||= UserSetting.find_by(user_id: self.id)
  rescue Mongoid::Errors::DocumentNotFound
    nil
  end

  def user_setting=(settings)
    if user_setting
      user_setting.update(**settings)
    else
      UserSetting.create!(user_id: self.id, **settings)
    end
  end
end
