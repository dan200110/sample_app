module Api
  module V1
    module Ad
      class AdminsController < Base
        before_action :find_admin, except: %i(create)

        def show
          render json: @admin.as_json, status: :ok
        end

        def create
          @admin = Employee.new admin_params.merge(role: "admin")
          if
            @admin.save!
            render json: @admin.as_json, status: :ok
          end
        rescue StandardError => e
          render json: { error: e.message }, status: :bad_request
        end

        def update
          if @admin.update(admin_params)
            render json: @admin.as_json, status: :ok
          else
            render json: { error: @admin.errors }, status: :bad_request
          end
        end

        private

        def admin_params
          params.permit(:name, :email, :password, :password_confirmation)
        end

        def find_admin
          @admin = Admin.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end
      end
    end
  end
end
