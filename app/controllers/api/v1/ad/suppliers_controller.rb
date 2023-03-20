module Api
  module V1
    module Ad
      class SuppliersController < Base
        before_action :authenticate_admin!
        before_action :find_supplier, except: %i(create index)

        def index
          @suppliers = Supplier.all

          render json: @suppliers.as_json, status: :ok
        end

        def show
          render json: @supplier.as_json(include: { inventory: { except: %i[] } }), status: :ok
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

        def update
          if @supplier.update(supplier_params)
            render json: @supplier.as_json, status: :ok
          else
            render json: { error: @supplier.errors }, status: :bad_request
          end
        end

        def destroy
          @supplier.destroy!
          head :ok
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end

        private

        def supplier_params
          params.permit(:name, :contact, :email, :address)
        end

        def find_supplier
          @supplier = Supplier.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end
      end
    end
  end
end
