class Branch < ApplicationRecord
  has_many :employee
  has_many :inventory
  has_many :order
  has_many :import_inventory
end
