class PromotionsController < ApplicationController
    before_action :authenticate_user!
    before_action :promotion_find_by_id, only: %i[edit update destroy]

    def index
        @promotions = Promotion.all()
    end

    def new
        @product_categories = ProductCategory.all()
        @promotion = Promotion.new()
    end

    def create
        @promotion = Promotion.new(promotion_params())
        @promotion.user = current_user

        if @promotion.save()
            redirect_to promotion_path(id: @promotion.id)
        else
            @product_categories = ProductCategory.all()
            render :new
        end
    end

    def show
        @promotion = Promotion.find(params[:id])
    end

    def edit
    end

    def update
        @promotion.user = current_user
        if @promotion.update(promotion_params())
            flash[:notice] = 'Promoção atualizada com sucesso!'
            redirect_to promotion_path(id: @promotion.id)
        else
            render :edit
        end
    end

    def destroy
        if @promotion.destroy
            redirect_to promotions_path
        else
            render :show
        end
    end

    def generate_coupons
        @promotion = Promotion.find(params[:id])
        @promotion.generate_coupons!
        flash[:notice] = t('messages.create', item: Coupon.model_name.human(count: 2))
        redirect_to promotion_path(id: @promotion.id)
    end

    def approve
        promotion = Promotion.find(params[:id])
        promotion.approve!(current_user)
        redirect_to promotion
    end

    def search
        @promotions = Promotion.where('name like ? OR description like ?', "%#{params[:term]}%", "%#{params[:term]}%")
    end

    private
    def promotion_params
        params.require(:promotion).permit(
            :name, :description, :code, :discount_rate, 
            :expiration_date, :coupon_quantity, product_category_ids: []
        )
    end

    def promotion_find_by_id
        @promotion = Promotion.find(params[:id])
    end
end