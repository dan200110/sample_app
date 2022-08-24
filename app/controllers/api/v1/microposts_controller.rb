module Api
  module V1
    class MicropostsController < Base
      before_action :authenticate_user!
      before_action :find_micropost, only: :destroy

      def create
        @micropost = @current_user.microposts.build(micropost_params)
        @micropost.image.attach(params[:micropost][:image])
        if @micropost.save!
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@micropost, serializer: MicropostSerializer),
            message: ["Micropost create fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @micropost, status: :created, location: @micropost
        end
      end

      def destroy
        if @micropost.destroy!
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@micropost, serializer: MicropostSerializer),
            message: ["Micropost destroy fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @micropost, status: :deleted, location: @micropost
        end
      end

      private

      def micropost_params
        params.require(:micropost).permit(:content, :image)
      end

      def find_micropost
        @micropost = @current_user.microposts.find_by(id: params[:id])
        return if @micropost

        render json: {
          message: ["Not found micropost"],
          status: 400,
          type: "Fail"
        }, status: :bad_request
      end
    end
  end
end
