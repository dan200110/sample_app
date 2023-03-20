module Api
  module V1
    module Ad
      class StatisticController < Base
        before_action :authenticate_admin!

        def get_total_order_price
          @orders_all = Order.all
          @orders_today = Order.all.time_between(Time.now.beginning_of_day, Time.now)
          @orders_week = Order.all.time_between(Time.now.beginning_of_week, Time.now)
          @orders_month = Order.all.time_between(Time.now.beginning_of_month, Time.now)
          @orders_year = Order.all.time_between(Time.now.beginning_of_year, Time.now)
          render json: {
            all: @orders_all.pluck(:total_price).sum,
            today: @orders_today.pluck(:total_price).sum,
            week: @orders_week.pluck(:total_price).sum,
            month: @orders_month.pluck(:total_price).sum,
            year: @orders_year.pluck(:total_price).sum
          }, status: :ok
        end

        def get_order_by_day
          @order_by_day = Order.order_by_day

          render json: @order_by_day , status: :ok
        end

        def get_revenue_order
          if params[:type] == "week"
            @revenue = Order.all.revenue_week_chart
          elsif params[:type] == "month"
            @revenue = Order.all.revenue_month_chart
          else
            @revenue = Order.all.revenue_day_chart
          end
          render json: @revenue , status: :ok
        end

        def get_order_by_branch
          @order_by_branch = Branch.order_by_branch

          render json: @order_by_branch, status: :ok
        end
      end
    end
  end
end
