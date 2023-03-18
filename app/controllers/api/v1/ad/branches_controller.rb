module Api
  module V1
    module Ad
      class BranchesController < Base
        before_action :find_branch, except: %i(create index)
        before_action :authenticate_admin!

        def index
          @branches = Branch.all

          render json: @branches.as_json, status: :ok
        end

        def show
          render json: @branch.as_json, status: :ok
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

        def update
          if @branch.update(branch_params)
            render json: @branch.as_json, status: :ok
          else
            render json: { error: @branch.errors }, status: :bad_request
          end
        end

        def destroy
          @branch.destroy!
          head :ok
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end

        private

        def branch_params
          params.permit(:name, :address, :branch_code, :email, :contact)
        end

        def find_branch
          @branch = Branch.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end
      end
    end
  end
end
