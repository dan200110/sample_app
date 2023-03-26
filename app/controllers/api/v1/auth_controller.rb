module Api
  module V1
    class AuthController < Base
      def create
        employee = Employee.find_by email: params[:email]
        if employee&.authenticate params[:password]
          generate_token employee
          render json: {access_token: @data[:access_token], employee_id: employee&.id, employee_name: employee&.name, employee_email: employee&.email, role: employee&.role}, status: :ok
        else
          render json: {message: "Invalid email or password combination", success: false}, status: :unauthorized
        end
      end

      def generate_token employee

        access_token = JsonWebToken.encode(employee_id: employee.id)
        @data = {
          access_token: access_token,
          token_type: "Bearer"
        }
      end
    end
  end
end
