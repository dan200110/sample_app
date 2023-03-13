module Api
  module V1
    class InventoriesController < Base
      before_action :authenticate_employee!
      before_action :find_inventory, only: %i(show update destroy)

      def index
        @inventories = @current_branch.inventory.search_by_name(params["search_name"])
        render json: @inventories.map {|inventory|
          if inventory.image.attached?
            inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]).merge({image: url_for(inventory.image)})
          else
            inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id])
          end
        }, status: :ok
      end

      def create
        @inventory = Inventory.new inventory_params.merge(inventory_code: generate_inventory_code)
        render json: @inventory.as_json, status: :ok if @inventory.save!
      rescue StandardError => e
        render json: {error: e.message}, status: :bad_request
      end

      def show
        if @inventory.image.attached?
          render json: @inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]).merge({image: url_for(@inventory.image)}), status: :ok
        else
          render json: @inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]), status: :ok
        end
      end

      def get_expired
        day_left = params[:day_left].present? ? params[:day_left].to_i : 0
        batch_expired = BatchInventory.get_expired(day_left).pluck :id

        @expired_inventories = Inventory.where(batch_inventory_id: batch_expired, branch_id: @current_branch.id)
        render json: @expired_inventories.map {|inventory|
          if inventory.image.attached?
            inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]).merge({image: url_for(inventory.image)})
          else
            inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id])
          end
        }, status: :ok
      end

      def get_out_of_stock
        quantity_left = params[:quantity_left].present? ? params[:quantity_left].to_i : 0
        @out_of_stock_inventories = Inventory.where(branch_id: @current_branch.id).get_out_of_stock(quantity_left)

        render json: @out_of_stock_inventories.map {|inventory|
          if inventory.image.attached?
            inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id]).merge({image: url_for(inventory.image)})
          else
            inventory.as_json(except: %i[category_id batch_inventory_id supplier_id branch_id])
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
                      :supplier_id, :image, :main_ingredient, :producer)
      end

      def find_inventory
        @inventory = Inventory.find_by! id: params[:id]
      rescue StandardError => e
        render json: { errors: e.message }, status: :bad_request
      end

      def generate_inventory_code
        "INVENTORY_CODE" + Time.now.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end
