class ImportInventory < ApplicationRecord
  belongs_to :branch
  belongs_to :inventory
  belongs_to :batch_inventory
  belongs_to :supplier
  belongs_to :employee, optional: true
  
  enum status: {pending: 1, complete: 0}

  scope :search_by_branch, lambda { |branch_id| where(branch_id: branch_id) if branch_id.present? }
  scope :time_between, lambda { |start_time, end_time|
    where(created_at: start_time..end_time) if start_time.present? && end_time.present?
  }
  scope :order_by_day, (lambda do
    group("date(created_at)").count
  end)

  scope :order_by_month, (lambda do
    group("month(created_at)").count
  end)

  scope :revenue_day_chart, (lambda do
    group("date(created_at)").sum :price
  end)

  scope :revenue_month_chart, (lambda do
    group("month(created_at)").sum :price
  end)

  def as_json(options = {})
    super(options).tap do |j|
      j.merge!(created_date: created_at&.strftime('%Y-%m-%d'))
    end
  end
end
