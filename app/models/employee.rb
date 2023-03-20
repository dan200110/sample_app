class Employee < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  belongs_to :branch
  scope :latest_employee, ->{order(created_at: :desc)}
  scope :search_by_branch, lambda { |branch_id| where(branch_id: branch_id) if branch_id.present? }
  EMPLOYEE_ATTRS = %w(name email password password_confirmation branch_id).freeze
  before_save :downcase_email

  validates :email, presence: true,
    length: {minimum: Settings.employee.email.email_min_length},
    format: {with: Settings.employee.VALID_EMAIL_REGEX},
    uniqueness: true

  validates :name, presence: true,
    length: {maximum: Settings.employee.name_validates.name_max_length}

  validates :password, presence: true,
    length: {minimum: Settings.employee.password_validates.password_min_length}, if: :password, allow_nil: true

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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
