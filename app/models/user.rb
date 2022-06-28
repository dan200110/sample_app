class User < ApplicationRecord
  before_save :downcase_email

  validates :email, presence: true,
    length: Settings.user.email.email_length_range,
    format: {with: Settings.user.valid_email_regex},
    uniqueness: true

  validates :name, presence: true,
    length: {maximum: Settings.user.name_validates.name_max_length}

  validates :password, presence: true,
    length: {minimum: Settings.user.password_validates.password_min_lenght}, if: :password

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
