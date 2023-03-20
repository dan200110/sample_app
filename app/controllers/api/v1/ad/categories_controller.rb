module Api
  module V1
    module Ad
      class CategoriesController < Base
        before_action :authenticate_admin!
        before_action :find_category, except: %i(create index)

        def index
          @categories = Category.all

          render json: @categories.as_json, status: :ok
        end

        def show
          render json: @category.as_json(include: { inventory: { except: %i[] } }), status: :ok
        end

        def create
          @category = Category.new category_params
          if
            @category.save!
            render json: @category.as_json, status: :ok
          end
        rescue StandardError => e
          render json: { error: e.message }, status: :bad_request
        end

        private

        def category_params
          params.permit(:name)
        end

        def find_category
          @category = Category.find_by! id: params[:id]
        rescue StandardError => e
          render json: { errors: e.message }, status: :bad_request
        end
      end
    end
  end
end
