module Api
  module V1
    class InventoriesController < Base
      before_action :authenticate_employee!
      before_action :find_inventory, except: %i(create index get_expired)

      def index
        @inventories = @current_branch.inventory.search_by_name(params["search_name"])
        render json: @inventories.map {|inventory|
          if inventory.image.attached?
            inventory.as_json.merge({image: url_for(inventory.image)})
          else
            inventory.as_json
          end
        }, status: :ok
      end

      def create
        @inventory = Inventory.new inventory_params
        render json: @inventory.as_json, status: :ok if @inventory.save!
      rescue StandardError => e
        render json: {error: e.message}, status: :bad_request
      end

      def show
        if @inventory.image.attached?
          render json: @inventory.as_json.merge({image: url_for(@inventory.image)}), status: :ok
        else
          render json: @inventory.as_json, status: :ok
        end
      end

      def get_expired
        batch_expired = BatchInventory.get_expired.pluck :id

        @expired_inventories = Inventory.where(batch_inventory_id: batch_expired)
        render json: @expired_inventories.map {|inventory|
          if inventory.image.attached?
            inventory.as_json.merge({image: url_for(inventory.image)})
          else
            inventory.as_json
          end
        }, status: :ok
      end

      def update
        if @inventory.update(inventory_params)
          render json: @inventory.as_json, status: :ok
        else
          render json: { error: @inventory.errors }, status: :bad_request
        end
      end

      def destroy
        @inventory.destroy!
        head :ok
      rescue StandardError => e
        render json: { errors: e.message }, status: :bad_request
      end

      private

      def inventory_params
        params.permit(:name, :price, :inventory_type, :quantity, :category_id, :batch_inventory_id, :branch_id,
                      :supplier_id, :image)
      end

      def find_inventory
        @inventory = Inventory.find_by! id: params[:id]
      rescue StandardError => e
        render json: { errors: e.message }, status: :bad_request
      end
    end
  end
end
