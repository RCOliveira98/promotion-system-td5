class PromotionsController < ApplicationController
    before_action :promotion_find_by_id, only: %i[edit update destroy]

    def index
        @promotions = Promotion.all()
    end

    def new
        @promotion = Promotion.new()
    end

    def create
        @promotion = Promotion.new(promotion_params())
        if @promotion.save()
            redirect_to promotion_path(id: @promotion.id)
        else
            render :new
        end
    end

    def show
        @promotion = Promotion.find(params[:id])
    end

    def edit
    end

    def update
        if @promotion.update(promotion_params())
            flash[:notice] = 'Promoção atualizada com sucesso!'
            redirect_to promotion_path(id: @promotion.id)
        else
            render :edit
        end
    end

    def generate_coupons
        @promotion = Promotion.find(params[:id])
        1.upto(@promotion.coupon_quantity) { |number| Coupon.create(code: "#{@promotion.code}-#{'%04d' % number}", promotion: @promotion) }
        flash[:notice] = 'Cupons gerados com sucesso'
        redirect_to promotion_path(id: @promotion.id)
    end

    private
    def promotion_params
        params.require(:promotion).permit(:name, :description, :code, :discount_rate, :expiration_date, :coupon_quantity)
    end

    def promotion_find_by_id
        @promotion = Promotion.find(params[:id])
    end
end