class Course < ApplicationRecord
  has_many :enrollments
  has_many :users, through: :enrollments

  enum :status, %w[draft published]

  scope :drafts, -> { where(status: "draft") }

  def publish!
    self.status = "published"
    save
  end
end
