class RefreshToken < ApplicationRecord
  belongs_to :user

  before_create :set_token_and_expiration

  private

  def set_token_and_expiration
    self.token = SecureRandom.hex(32)
    self.expires_at = 30.days.from_now
  end
end
