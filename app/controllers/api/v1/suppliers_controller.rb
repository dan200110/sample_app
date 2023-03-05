module Api
  module V1
    class SuppliersController < Base
      before_action :authenticate_employee!

      def index
        @suppliers = Supplier.all

        render json: @suppliers.as_json, status: :ok
      end

      def create
        @supplier = Supplier.new supplier_params
        if
          @supplier.save!
          render json: @supplier.as_json, status: :ok
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def supplier_params
        params.permit(:name, :contact)
      end
    end
  end
end
