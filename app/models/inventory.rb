class Inventory < ApplicationRecord
  belongs_to :branch
  belongs_to :batch_inventory
  belongs_to :supplier
  belongs_to :category, optional: true
  has_many :order

  enum inventory_type: { pill: 0, blister_packs: 1, pill_pack: 2, pill_bottle: 3 }

  has_one_attached :image
  validates :quantity, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 999_999 }, allow_blank: true
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }, allow_blank: true

  scope :search_by_name, lambda { |search| where("name LIKE ? OR inventory_code LIKE ?", "%#{search}%", "%#{search}%") if search.present? }
  scope :get_out_of_stock, lambda { |quantity| where(quantity: ..quantity) }

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  def as_json(options = {})
    super(options).tap do |j|
      j.merge!(branch: branch.as_json(except: %i[created_at updated_at]))
      j.merge!(category: category.as_json(except: %i[created_at updated_at]))
      j.merge!(batch_inventory: batch_inventory.as_json(except: %i[created_at updated_at]))
      j.merge!(supplier: supplier.as_json(except: %i[created_at updated_at]))
    end
  end

  def send_request_email_to_supplier
    InventoryMailer.send_request_mail_to_supplier(self).deliver_now
  end
end
