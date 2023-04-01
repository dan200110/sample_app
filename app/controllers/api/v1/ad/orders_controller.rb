module Api
  module V1
    module Ad
      class OrdersController < Base
        before_action :authenticate_admin!
        before_action :find_order, except: %i(create index)
        before_action :check_quantity, only: %i(create)

        def index
          @orders = Order.search_by_branch(params["branch_id"]).time_between(params[:start_date]&.to_time, params[:end_date]&.to_time)
          render json: @orders.as_json(
            include: {
              inventory: { only: %i[id inventory_code name price quantity main_ingredient producer] },
              branch: { except: %i[created_at updated_at] },
              employee: { except: %i[created_at updated_at] }
            }
          ), status: :ok
        end

        def create
          @order = Order.new order_params.merge(order_code: generate_order_code, branch_id: @current_branch.id, employee_id: @current_employee.id)
          if @order.save!
            reduce_inventory_quantity
            render json: @order.as_json(
              include: {
                inventory: { only: %i[id inventory_code name price quantity main_ingredient producer] },
                branch: { except: %i[created_at updated_at] },
                employee: { except: %i[created_at updated_at] }
              }
            ), status: :ok
          end
        rescue StandardError => e
          render json: {error: e.message}, status: :bad_request
        end

        def show
          render json: @order.as_json(
            include: {
              inventory: { only: %i[id inventory_code name price quantity main_ingredient producer] },
              branch: { except: %i[created_at updated_at] },
              employee: { except: %i[created_at updated_at] }
            }
          ), status: :ok
        end

        private

        def order_params
          params.permit(:total_price, :total_quantity, :status, :inventory_id, :customer_name)
        end

        def find_order
          @order = Order.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end

        def check_quantity
          @inventory = Inventory.find_by! id: params[:inventory_id]
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

        def generate_order_code
          "ORDER_CODE_" + Time.now.strftime('%Y%m%d%H%M%S')
        end
      end
    end
  end
end
