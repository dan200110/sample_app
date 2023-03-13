module Api
  module V1
    class ImportInventoriesController < Base
      before_action :authenticate_employee!
      before_action :find_import_inventory, except: %i(create index)

      def index
        @import_inventories = ImportInventory.all

        render json: @import_inventories.as_json, status: :ok
      end

      def show
        render json: @import_inventory.as_json, status: :ok
      end

      def create
        @import_inventory = ImportInventory.new import_inventory_params.merge(import_inventory_code: generate_import_inventory_code)
        if @import_inventory.save!
          update_inventory
          render json: @import_inventory.as_json, status: :ok
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def import_inventory_params
        params.permit(:name, :price, :quantity, :batch_inventory_id, :inventory_id, :branch_id, :supplier_id, :import_inventory_code, :status)
      end

      def update_inventory_params
        params.permit(:name, :price, :quantity, :batch_inventory_id, :supplier_id)
      end

      def update_inventory
        inventory = Inventory.find_by(id: import_inventory_params["inventory_id"])
        update_data = update_inventory_params
        update_data["quantity"] = update_data["quantity"].to_i + inventory.quantity

        inventory.update!(update_data)
      end

      def find_import_inventory
        @import_inventory = ImportInventory.find_by! id: params[:id]
      rescue StandardError => e
        render json: { errors: e.message }, status: :bad_request
      end

      def generate_import_inventory_code
        "IMPORT_CODE" + Time.now.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
