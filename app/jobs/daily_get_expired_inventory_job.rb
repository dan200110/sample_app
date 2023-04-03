class DailyGetExpiredInventoryJob < ApplicationJob
  def perform
    @branches = Branch.all
    batch_expired = BatchInventory.get_expired(0).pluck :id
    @branches.each do |branch|
      @expired_inventories = Inventory.where(batch_inventory_id: batch_expired, branch_id: branch.id)
      branch.send_daily_expired(@expired_inventories)
    end
  end
end
