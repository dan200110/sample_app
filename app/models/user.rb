class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token

  scope :latest_user, ->{order(created_at: :desc)}
  USER_ATTRS = %w(name email password password_confirmation).freeze
  before_save :downcase_email
  before_create :create_activation_digest

  validates :email, presence: true,
    length: {minimum: Settings.user.email.email_min_length},
    format: {with: Settings.user.VALID_EMAIL_REGEX},
    uniqueness: true

  validates :name, presence: true,
    length: {maximum: Settings.user.name_validates.name_max_length}

  validates :password, presence: true,
    length: {minimum: Settings.user.password_validates.password_min_length}, if: :password, allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
