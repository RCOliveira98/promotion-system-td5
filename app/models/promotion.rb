class Promotion < ApplicationRecord
    validates :name, :discount_rate, :coupon_quantity, :expiration_date, presence: true
    validates :code, presence: true, uniqueness: true    

    has_many :coupons, dependent: :destroy
    belongs_to :user
    
    before_save :code_upcase

    def generate_coupons!
        Coupon.transaction do
            coupons.insert_all! build_coupon_matrix()
        end
    end

    private
    def code_upcase
        code.upcase!
    end

    def build_coupon_matrix
        coupons_list = []

        1.upto(coupon_quantity) do |number| 
            coupons_list << {code: "#{code}-#{'%04d' % number}", promotion_id: id, created_at: Time.current, updated_at: Time.current}
        end

        coupons_list
    end
end
