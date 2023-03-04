module Api
  module V1
    class UsersController < Base
      before_action :authenticate_user!
      before_action :find_user, except: %i(create index)
      before_action :correct_user, only: %i(update)
      before_action :admin_user, only: %i(destroy)

      def index
        @pagy, @users = pagy User.latest_user
        render json: {
          data: ActiveModelSerializers::SerializableResource.new(@users, each_serializer: UserSerializer),
          message: ["User list fetched successfully"],
          status: 200,
          type: "Success",
          page: @pagy
        }
      end

      def show
        @pagy, @microposts = pagy @user.microposts
        render json: {
          data: ActiveModelSerializers::SerializableResource.new(@microposts, each_serializer: MicropostSerializer),
          message: ["User profile fetched successfully"],
          status: 200,
          type: "Success"
        }
      end

      def update
        if @user.update! user_params
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@user, serializer: UserSerializer),
            message: ["User update fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @user, status: :updated, location: @user
        end
      end

      def destroy
        if @user.destroy!
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@user, serializer: UserSerializer),
            message: ["User destroy fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @user, status: :deleted, location: @user
        end
      end

      def create
        @user = User.new user_params
        if @user.save!
          @user.send_activation_email
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@user, serializer: UserSerializer),
            message: ["User create fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @user, status: :created, location: @user
        end
      end

      private

      def user_params
        params.require(:user).permit(User::USER_ATTRS)
      end

      def find_user
        @user = User.find_by! id: params[:id]
        return if @user

        render json: {
          message: ["Not found user"],
          status: 400,
          type: "Fail"
        }, status: :bad_request
      end

      def correct_user
        return if @current_user == @user

        render json: {
          message: ["Not correct user"],
          status: 400,
          type: "Fail"
        }, status: :bad_request
      end

      def admin_user
        return if @current_user.admin?

        render json: {
          message: ["Not admin"],
          status: 400,
          type: "Fail"
        }, status: :bad_request
      end
    end
  end
end
