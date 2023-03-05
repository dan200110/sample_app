module Api
  module V1
    class InventoriesController < Base
      before_action :authenticate_employee!
      before_action :find_inventory, except: %i(create index)

      def index
        if params["search_name"].present?
          @inventories = Inventory.search_by_name(params["search_name"])
        else
          @inventories = Inventory.all
        end

        render json: @inventories.as_json, status: :ok
      end

      def create

        @inventory = Inventory.new inventory_params
        if
          @inventory.save!
          render json: @inventory.as_json, status: :ok
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      def show
        render json: @inventory.as_json.merge({ image: url_for(@inventory.image) }), status: :ok

      end

      private

      def inventory_params
        params.permit(:name, :price, :inventory_type, :quantity, :category_id, :batch_inventory_id, :branch_id, :supplier_id, :image)
      end

      def find_inventory
        @inventory = Inventory.find_by! id: params[:id]
        return if @inventory

        render json: {
          message: ["Not found inventory"],
          status: 400,
          type: "Fail"
        }, status: :bad_request
      end
    end
  end
end
