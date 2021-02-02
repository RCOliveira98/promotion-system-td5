class PromotionsController < ApplicationController

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
end