module Api
  module V1
    class PasswordController < Base
      def forgot
        if params[:email].blank?
          return render json: {error: 'Email not present'}
        end

        employee = Employee.find_by(email: params[:email].downcase)

        if employee.present?
          employee.generate_password_token!
          # SEND EMAIL HERE
          render json: {status: 'ok'}, status: :ok
        else
          render json: {error: ['Email address not found. Please check and try again.']}, status: :not_found
        end
      end

      def reset
        token = params[:token].to_s

        if params[:email].blank?
          return render json: {error: 'Token not present'}
        end

        employee = Employee.find_by(reset_password_token: token)

        if employee.present? && employee.password_token_valid?
          if employee.reset_password!(params[:password])
            render json: {status: 'ok'}, status: :ok
          else
            render json: {error: employee.errors.full_messages}, status: :unprocessable_entity
          end
        else
          render json: {error:  ['Link not valid or expired. Try generating a new link.']}, status: :not_found
        end
      end
    end
  end
end
