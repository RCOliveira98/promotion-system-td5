class ProductCategory < ApplicationRecord
    validates :name, presence: true
    validates :code, presence: true, uniqueness: true

    has_many :product_category_promotions
    has_many :promotions, through: :product_category_promotions
end
