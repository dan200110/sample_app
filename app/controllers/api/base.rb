module Api
  class Base < ActionController::API
    include Pagy::Backend
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response
    protected

    def render_unprocessable_entity_response error, status: :unprocessable_entity
      render json: Errors::ActiveRecordValidation.new(error.record).to_hash, status: status
    end

    def render_record_not_found_response error, status: :not_found
      
      render json: Errors::ActiveRecordNotFound.new(
        error).to_hash, status: status
    end

    def authenticate_user!
      token = request.headers["Jwt-Token"]
      user_id = JsonWebToken.decode(token)["user_id"] if token
      @current_user = User.find_by id: user_id
      return if @current_user

      render json: {
        message: ["You need to log in to use the app"],
        status: 401,
        type: "failure"
      }, status: :unauthorized
    end
  end
end
