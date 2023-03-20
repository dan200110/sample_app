class ImportInventory < ApplicationRecord
  belongs_to :branch
  belongs_to :inventory
  belongs_to :batch_inventory
  belongs_to :supplier
  belongs_to :employee, optional: true

  scope :search_by_branch, lambda { |branch_id| where(branch_id: branch_id) if branch_id.present? }
end
