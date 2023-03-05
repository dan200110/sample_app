module Api
  module V1
    class BatchInventoriesController < Base
      before_action :authenticate_employee!

      def index
        @batch_inventories = BatchInventory.all

        render json: @batch_inventories.as_json, status: :ok
      end

      def create
        @batch_inventory = BatchInventory.new batch_inventory_params
        if
          @batch_inventory.save!
          render json: @batch_inventory.as_json, status: :ok
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def batch_inventory_params
        params.permit(:batch_code, :expired_date)
      end
    end
  end
end
