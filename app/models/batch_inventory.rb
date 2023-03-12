class BatchInventory < ApplicationRecord
  has_many :inventory

  scope :get_expired, lambda { |day_left| where(expired_date: ..Date.today + day_left.days) }
end
