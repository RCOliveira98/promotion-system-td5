class Promotion < ApplicationRecord
    validates :name, :discount_rate, :coupon_quantity, :expiration_date, presence: true
    validates :code, presence: true, uniqueness: true

    has_many :coupons, dependent: :destroy
end
