module Api
  module V1
    module Ad
      class BatchInventoriesController < Base
        before_action :authenticate_admin!
        before_action :find_batch_inventory, except: %i(create index get_all_expired)

        def index
          @batch_inventories = BatchInventory.all

          render json: @batch_inventories.as_json, status: :ok
        end

        def show
          render json: @batch_inventory.as_json, status: :ok
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

        def get_all_expired
          batch_expired = BatchInventory.get_expired

          render json: batch_expired.as_json(include: { inventory: { only: %i[id inventory_code name] } }), status: :ok
        end

        private

        def batch_inventory_params
          params.permit(:batch_code, :expired_date)
        end

        def find_batch_inventory
          @batch_inventory = BatchInventory.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end
      end
    end
  end
end
