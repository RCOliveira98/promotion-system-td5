class ProductCategoriesController < ApplicationController

    before_action :product_category_find_by_id, only: %i[show edit update destroy]

    def index
        @product_categories = ProductCategory.all
    end

    def new
        @product_category = ProductCategory.new
    end

    def create
        @product_category = ProductCategory.new(product_category_params())
        if @product_category.save()
            redirect_to product_categories_path
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @product_category.update(product_category_params())
            redirect_to product_categories_path
        else
            render :edit
        end
    end

    private
    def product_category_params
        params.require(:product_category).permit(:id, :name, :code)
    end

    def product_category_find_by_id
        @product_category = ProductCategory.find(params[:id])
    end
end