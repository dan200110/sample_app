module Api
  module V1
    class ImportInventoriesController < Base
      def create

        @import_inventory = ImportInventory.new import_inventory_params
        if
          @import_inventory.save!
          render json: @import_inventory.as_json, status: :ok
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def import_inventory_params
        params.permit(:name, :price, :inventory_type, :quantity, :date, :category_id, :batch_inventory_id, :inventory_id)
      end
    end
  end
end
