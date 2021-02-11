class CouponsController < ApplicationController

    def inactivate
        @coupon = Coupon.find(params[:id])

        @coupon.inactive!

        redirect_to promotion_path(@coupon.promotion)
    end

    def search
        begin
            promotion = get_promotion()
            get_coupon()
        rescue => exception
            p "[coupons_controller=>search: exception] #{exception}"
            flash[:alert] = "Não foi encontrado nenhum cupom com id de #{params[:search_id]}"
            @promotion = promotion
            render 'promotions/show'
        end
    end

    private

    def get_coupon
        @coupon = Coupon.find(params[:search_id])
    end

    def get_promotion
        Promotion.find(params[:promotion])
    end
end