class Inventory < ApplicationRecord
  belongs_to :branch
  belongs_to :batch_inventory, optional: true
  belongs_to :supplier, optional: true
  belongs_to :category, optional: true
  has_many :order
  has_many :import_inventories

  enum inventory_type: { pill: 0, blister_packs: 1, pill_pack: 2, pill_bottle: 3 }

  has_one_attached :image
  validates :quantity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999_999 }, allow_blank: true
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }, allow_blank: true

  scope :search_by_name, lambda { |search| where("name LIKE ? OR inventory_code LIKE ?", "%#{search}%", "%#{search}%") if search.present? }
  scope :search_by_branch, lambda { |branch_id| where(branch_id: branch_id) if branch_id.present? }
  scope :get_out_of_stock, lambda { |quantity| where(quantity: ..quantity) }

  scope :most_ordered, (lambda do
    joins(:order).order("sum_total_quantity DESC").group(:id).sum(:total_quantity)
  end)

  scope :sort_price, ->(type){order price: type if type.present?}
  scope :sort_created_time, ->(type){order created_at: type if type.present?}

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  def as_json(options = {})
    super(options).tap do |j|
      j.merge!(branch: branch.as_json(except: %i[created_at updated_at]))
      j.merge!(category: category.as_json(except: %i[created_at updated_at]))
      j.merge!(batch_inventory: batch_inventory.as_json(except: %i[created_at updated_at]))
      j.merge!(supplier: supplier.as_json(except: %i[created_at updated_at]))
      j.merge!(total_order_quantity: total_order_quantity)
      j.merge!(created_date: created_at&.strftime('%Y-%m-%d'))
    end
  end

  def send_request_email_to_supplier
    InventoryMailer.send_request_mail_to_supplier(self).deliver_now
  end

  def total_order_quantity
    order.sum(:total_quantity)
  end
end
