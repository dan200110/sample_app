class Order < ApplicationRecord
  belongs_to :branch
  belongs_to :inventory

end
