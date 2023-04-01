module Api
  module V1
    class StatisticController < Base
      before_action :authenticate_employee!

      def get_total_order_price
        @orders_all = @current_branch.order
        @orders_today = @current_branch.order.time_between(Time.now.beginning_of_day, Time.now)
        @orders_week = @current_branch.order.time_between(Time.now.beginning_of_week, Time.now)
        @orders_month = @current_branch.order.time_between(Time.now.beginning_of_month, Time.now)
        @orders_year = @current_branch.order.time_between(Time.now.beginning_of_year, Time.now)
        render json: {
          all: @orders_all.pluck(:total_price).sum,
          today: @orders_today.pluck(:total_price).sum,
          week: @orders_week.pluck(:total_price).sum,
          month: @orders_month.pluck(:total_price).sum,
          year: @orders_year.pluck(:total_price).sum
        }, status: :ok
      end

      def header_statistic
        @orders_month = @current_branch.order.time_between(Time.now.beginning_of_month, Time.now.end_of_month)
        @order_month_count = @orders_month&.count
        @order_month_price = @orders_month&.sum('total_price * total_quantity') || 0

        @order_pre_month = @current_branch.order.time_between((Time.now - 1.month).beginning_of_month, (Time.now - 1.month).end_of_month)
        @order_pre_month_price = @order_pre_month&.sum('total_price * total_quantity') || 0
        @order_percent_from_last_month = @order_pre_month_price == 0 || @order_month_price == 0  ? 'N/A' : (@order_month_price - @order_pre_month_price) / 100.0

        @import_inventories_month = @current_branch.import_inventory.time_between(Time.now.beginning_of_month, Time.now.end_of_month)
        @import_inventories_month_count = @import_inventories_month&.count
        @import_inventories_month_price = @import_inventories_month&.sum('price * quantity') || 0

        @im_pre_month = @current_branch.import_inventory.time_between((Time.now - 1.month).beginning_of_month, (Time.now - 1.month).end_of_month)
        @im_pre_month_price = @im_pre_month&.sum('price * quantity') || 0
        @im_percent_from_last_month = @im_pre_month_price == 0 || @import_inventories_month_price == 0 ? 'N/A' : (@import_inventories_month_price - @im_pre_month_price) / 100.0

        render json: {
          order_month_count: @order_month_count,
          order_month_price: @order_month_price,
          order_percent_from_last_month: @order_percent_from_last_month,
          import_inventories_month_count: @import_inventories_month_count,
          import_inventories_month_price: @import_inventories_month_price,
          im_percent_from_last_month: @im_percent_from_last_month
        }, status: :ok
      end

      def get_order_count
        if params[:type] == "month"
          @order_count = @current_branch.order.order_by_month
        else
          @order_count = @current_branch.order.order_by_day
        end
        render json: @order_count , status: :ok
      end

      def get_revenue_order
        if params[:type] == "month"
          @revenue = @current_branch.order.revenue_month_chart
        else
          @revenue = @current_branch.order.revenue_day_chart
        end
        render json: @revenue , status: :ok
      end

      def get_import_inventory_count
        if params[:type] == "month"
          @import_inventory_count = @current_branch.import_inventory.order_by_month
        else
          @import_inventory_count = @current_branch.import_inventory.order_by_day
        end
        render json: @import_inventory_count , status: :ok
      end

      def get_revenue_import_inventory
        if params[:type] == "month"
          @revenue = @current_branch.import_inventory.revenue_month_chart
        else
          @revenue = @current_branch.import_inventory.revenue_day_chart
        end
        render json: @revenue , status: :ok
      end
    end
  end
end
