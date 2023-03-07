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

  scope :search_by_name, lambda { |search| where("name LIKE ? OR id LIKE ?", "%#{search}%", "%#{search}%") if search.present? }

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end

  def as_json(options = {})
    super(options).tap do |j|
      j.merge!(category_name: category&.name)
      j.merge!(batch_inventory_name: batch_inventory&.batch_code)
    end
  end
end
