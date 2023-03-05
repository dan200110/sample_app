module Api
  module V1
    class BranchesController < Base
      def create
        @branch = Branch.new branch_params
        if @branch.save!
          render json: {
            data: ActiveModelSerializers::SerializableResource.new(@branch, serializer: BranchSerializer),
            message: ["Branch create fetched successfully"],
            status: 200,
            type: "Success"
          }
        else
          render json: @branch, status: :created, location: @branch
        end
      end

      private

      def branch_params
        params.permit(:name, :address, :branch_code)
      end
    end
  end
end
