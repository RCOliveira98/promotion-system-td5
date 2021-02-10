require 'rails_helper'

RSpec.describe PromotionApproval, type: :model do
  describe '#valid?' do
    describe '#creator_other_than_approver' do
      it 'has no promotion and user' do
        approval = PromotionApproval.new

        expect(approval.valid?).to eq false
      end

      it 'has no promotion' do
        user = User.new(email: 'rco@gmail.com', password: '123456')
        approval = PromotionApproval.new(user: user)

        expect(approval.valid?).to eq false
      end

      it 'has no user' do
        creator = User.new(email: 'rco@gmail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
          expiration_date: '22/12/2033', user: creator)
        approval = PromotionApproval.new(promotion: promotion)

        expect(approval.valid?).to eq false
      end

      it 'is the same' do
        creator = User.new(email: 'rco@gmail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
          expiration_date: '22/12/2033', user: creator)
        
        approval = PromotionApproval.new(user: creator, promotion: promotion)

        expect(approval.valid?).to eq false
      end

      it 'is the differect' do
        creator = User.new(email: 'rco@gmail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
          expiration_date: '22/12/2033', user: creator)
        
        approver = User.new(email: 'brenda@gmail.com', password: '123456')
        approval = PromotionApproval.new(user: approver, promotion: promotion)

        expect(approval.valid?).to eq true
      end

    end
  end
end
