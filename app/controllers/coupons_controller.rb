class CouponsController < ApplicationController

    def inactivate
        @coupon = Coupon.find(params[:id])

        @coupon.inactive!

        redirect_to promotion_path(@coupon.promotion)
    end
end