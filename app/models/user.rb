class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, :on => [:create, :reset_password]

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
