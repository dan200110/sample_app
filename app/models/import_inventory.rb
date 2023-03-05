class ImportInventory < ApplicationRecord
  belongs_to :branch
  belongs_to :inventory
  belongs_to :batch_inventory
  belongs_to :supplier
end
