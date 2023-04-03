class DailyGetOutOfStockInventoryJob < ApplicationJob
  def perform
    @branches = Branch.all
    @branches.each do |branch|
      @out_of_stock_inventories = Inventory.where(branch_id: branch.id).get_out_of_stock(0)
      branch.send_daily_out_of_stock(@out_of_stock_inventories)
    end
  end
end
