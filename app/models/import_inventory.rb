class ImportInventory < ApplicationRecord
  belongs_to :branch
  belongs_to :inventory
  belongs_to :batch_inventory
  belongs_to :supplier
  belongs_to :employee, optional: true

  scope :search_by_branch, lambda { |branch_id| where(branch_id: branch_id) if branch_id.present? }
  scope :time_between, lambda { |start_time, end_time|
    where(created_at: start_time..end_time) if start_time.present? && end_time.present?
  }

  def as_json(options = {})
    super(options).tap do |j|
      j.merge!(created_date: created_at&.strftime('%Y-%m-%d'))
    end
  end
end
