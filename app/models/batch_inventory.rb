class BatchInventory < ApplicationRecord
  has_many :inventory

  scope :get_expired, -> do
    where(expired_date: ..Date.today)
  end
end
