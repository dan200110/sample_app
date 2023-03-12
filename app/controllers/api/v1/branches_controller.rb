module Api
  module V1
    class BranchesController < Base
      def index
        @branches = Branch.all

        render json: @branches.as_json, status: :ok
      end

      def create
        @branch = Branch.new branch_params
        if
          @branch.save!
          render json: @branch.as_json, status: :ok
        end
      rescue StandardError => e
        render json: { error: e.message }, status: :bad_request
      end

      private

      def branch_params
        params.permit(:name, :address, :branch_code, :email)
      end
    end
  end
end
