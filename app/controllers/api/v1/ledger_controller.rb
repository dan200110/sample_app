module Api
  module V1
    class LedgerController < Base
      before_action :authenticate_employee!

      def index
        @orders = @current_branch.order.pluck(:id, :created_at, :total_price)
        @import_inventories = @current_branch.import_inventory

        render json: {
          orders: @orders.as_json,
          import_inventories: @import_inventories.as_json
        }, status: :ok
      end
    end
  end
end
