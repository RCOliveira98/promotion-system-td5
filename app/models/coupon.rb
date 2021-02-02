class Coupon < ApplicationRecord
  validates :code, presence: true
  belongs_to :promotion
end
