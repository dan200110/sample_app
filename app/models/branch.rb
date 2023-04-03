class Branch < ApplicationRecord
  has_many :employee
  has_many :inventory
  has_many :order
  has_many :import_inventory

  scope :order_by_branch, (lambda do
    joins(:order).group(:name).count
  end)

  def send_daily_expired(inventories)
    BranchMailer.send_daily_expired(self, inventories).deliver_now
  end

  def send_daily_out_of_stock(inventories)
    BranchMailer.send_daily_out_of_stock(self, inventories).deliver_now
  end
end
