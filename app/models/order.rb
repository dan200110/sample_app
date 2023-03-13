class Order < ApplicationRecord
  belongs_to :branch
  belongs_to :inventory

  scope :time_between, lambda { |start_time, end_time|
    where(created_at: start_time..end_time)
  }
end
