module Api
  module V1
    module Ad
      class AuthController < Base
        def create
          admin = Admin.find_by email: params[:email]
          if admin&.authenticate params[:password]
            generate_token admin
            render json: {access_token: @data[:access_token], admin_id: admin&.id, admin_name: admin&.name, admin_email: admin&.email}, status: :ok
          else
            render json: {message: "Invalid email or password combination", success: false}, status: :unauthorized
          end
        end

        def generate_token admin

          access_token = JsonWebToken.encode(admin_id: admin.id)
          @data = {
            access_token: access_token,
            token_type: "Bearer"
          }
        end
      end
    end
  end
end
