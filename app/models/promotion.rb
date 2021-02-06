class Promotion < ApplicationRecord
    validates :name, :discount_rate, :coupon_quantity, :expiration_date, presence: true
    validates :code, presence: true, uniqueness: true    

    has_many :coupons, dependent: :destroy
    before_save :code_upcase

    def generate_coupons!
        Coupon.transaction do
            1.upto(coupon_quantity) do |number| 
                coupons.create!(code: "#{code}-#{'%04d' % number}")
            end
        end
    end

    private
    def code_upcase
        code.upcase!
    end
end
