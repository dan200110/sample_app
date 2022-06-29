class User < ApplicationRecord
  USER_ATTRS = %w(name email password password_confirmation).freeze
  before_save :downcase_email

  validates :email, presence: true,
    length: {minimum: Settings.user.email.email_min_length},
    format: {with: Settings.user.VALID_EMAIL_REGEX},
    uniqueness: true

  validates :name, presence: true,
    length: {maximum: Settings.user.name_validates.name_max_length}

  validates :password, presence: true,
    length: {minimum: Settings.user.password_validates.password_min_length}, if: :password

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
