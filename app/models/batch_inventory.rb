class BatchInventory < ApplicationRecord
  has_many :inventory

  scope :get_expired, lambda { |day_left = 0| where(expired_date: ..Date.today + day_left.days)}
end
