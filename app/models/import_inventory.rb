class ImportInventory < ApplicationRecord
  belongs_to :branch
  belongs_to :inventory, optional: true
  belongs_to :batch_inventory, optional: true
  belongs_to :supplier, optional: true

end
