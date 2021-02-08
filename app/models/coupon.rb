class Coupon < ApplicationRecord
  validates :code, presence: true
  belongs_to :promotion
  enum status: { active: 1, inactive: 10 }
end
