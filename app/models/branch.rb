class Branch < ApplicationRecord
  has_many :employee
  has_many :inventory
  has_many :order
  has_many :import_inventory

  scope :order_by_branch, (lambda do
    joins(:order).group(:name).count
  end)
end
