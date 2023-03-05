class Inventory < ApplicationRecord
  belongs_to :branch
  belongs_to :batch_inventory
  belongs_to :supplier
  belongs_to :category, optional: true

  # enum inventory_type: { 0: 'pill', 1: 'blister_packs', 2: 'pill_pack', 3: 'pill_bottle' }
  has_one_attached :image

  scope :search_by_name, -> search { where("name LIKE ? OR id LIKE ?", "%#{search}%", "%#{search}%") }

  def image_url
    Rails.application.routes.url_helpers.url_for(image) if image.attached?
  end
end
