class Order < ApplicationRecord
  belongs_to :branch
  belongs_to :inventory
  belongs_to :employee, optional: true
  scope :time_between, lambda { |start_time, end_time|
    where(created_at: start_time..end_time)
  }

  scope :order_by_day, (lambda do
    group_by_day(:created_at).count
  end)

  scope :revenue_day_chart, (lambda do
    group_by_day(:created_at, range: 2.month.ago..Time.now).sum :total_price
  end)

  scope :revenue_week_chart, (lambda do
    group_by_week(:created_at, week_start: :monday).sum :total_price
  end)

  scope :revenue_month_chart, (lambda do
    group_by_month(:created_at).sum :total_price
  end)
end
