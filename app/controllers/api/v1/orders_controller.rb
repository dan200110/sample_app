module Api
  module V1
    class OrdersController < Base
      before_action :authenticate_employee!
      before_action :find_order, except: %i(create index)
      before_action :check_quantity, only: %i(create)

      def index
        @orders = @current_branch.order
        render json: @orders, status: :ok
      end

      def create
        @order = Order.new order_params
        if @order.save!
          reduce_inventory_quantity
          render json: @order.as_json, status: :ok
        end
      rescue StandardError => e
        render json: {error: e.message}, status: :bad_request
      end

      def show
        render json: @order.as_json, status: :ok
      end

      private

      def order_params
        params.permit(:total_price, :total_quantity, :status, :inventory_id, :branch_id)
      end

      def find_order
        @order = Order.find_by! id: params[:id]
      rescue StandardError => e
        render json: { errors: e.message }, status: :bad_request
      end

      def check_quantity
        @inventory = Inventory.find_by! id: params[:branch_id]
        if @inventory.quantity < params[:total_quantity].to_i
          render json: {error: "order quantity large than inventory quantity"}, status: :bad_request
          return
        end
      end

      def reduce_inventory_quantity
        @inventory = @order.inventory
        ivnentory_quantity = @inventory.quantity - @order.total_quantity
        @inventory.update_attribute :quantity, ivnentory_quantity
      end
    end
  end
end