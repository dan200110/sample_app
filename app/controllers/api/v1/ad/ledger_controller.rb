module Api
  module V1
    module Ad
      class LedgerController < Base
        before_action :authenticate_admin!

        def index
          @orders = Order.search_by_branch(params["branch_id"]).time_between(params[:start_date]&.to_time, params[:end_date]&.to_time)
          @import_inventories = ImportInventory.search_by_branch(params["branch_id"]).time_between(params[:start_date]&.to_time, params[:end_date]&.to_time)

          arr_order = @orders.map {|order|
            order.as_json(only: %i[created_at]).merge(
              {revenue: order.total_price * order.total_quantity, code: order&.order_code, type: "order"}
            )
          }

          arr_import_inventory = @import_inventories.map {|import_inventory|
            import_inventory.as_json(only: %i[created_at]).merge(
              {revenue: import_inventory.price * import_inventory.quantity, code: import_inventory&.import_inventory_code, type: "import_inventory"}
            )
          }

          arr_result = arr_order + arr_import_inventory
          render json: arr_result, status: :ok
        end
      end
    end
  end
end
