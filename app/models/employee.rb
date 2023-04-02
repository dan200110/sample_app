class Employee < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  belongs_to :branch, optional: true
  enum role: {admin: 0, employee: 1}
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

  validates :branch_id, presence: true, if: :employee?
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

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
    EmployeeMailer.password_reset(self).deliver_now
  end

  def password_token_valid?
    (self.reset_password_sent_at + 1.hours) > Time.now.utc
  end

  def reset_password! password
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def generate_token
    SecureRandom.hex(10)
  end
end
