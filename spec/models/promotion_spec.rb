require 'rails_helper'

describe Promotion do
  context 'validation' do
    it 'attributes cannot be blank' do
      promotion = Promotion.new

      promotion.valid?

      expect(promotion.errors[:name]).to include('não pode ficar em branco')
      expect(promotion.errors[:code]).to include('não pode ficar em branco')
      expect(promotion.errors[:discount_rate]).to include('não pode ficar em '\
                                                          'branco')
      expect(promotion.errors[:coupon_quantity]).to include('não pode ficar em'\
                                                            ' branco')
      expect(promotion.errors[:expiration_date]).to include('não pode ficar em'\
                                                            ' branco')
    end

    it 'code must be uniq' do
      user = User.create!(email: 'rco@gmail.com', password: '123456')

      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10,
                        coupon_quantity: 100, expiration_date: '22/12/2033', user: user)
      promotion = Promotion.new(code: 'NATAL10')

      promotion.valid?

      expect(promotion.errors[:code]).to include('já está em uso')
    end
  end

  context '#generate_coupons!' do
    it 'generate coupons of coupon_quantity' do
      user = User.create!(email: 'rco@gmail.com', password: '123456')

      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)

      promotion.generate_coupons!

      expect(promotion.coupons.size).to eq(100)
      codes = promotion.coupons.pluck(:code)
      expect(codes).to include('NATAL10-0001') # first
      expect(codes).to include('NATAL10-0100') # last
      expect(codes).not_to include('NATAL10-0000')
      expect(codes).not_to include('NATAL10-0101')
    end

    it 'do not generate if error' do
      user = User.create!(email: 'rco@gmail.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: user)
      promotion.coupons.create!(code: 'NATAL10-0030')

      expect { promotion.generate_coupons! }.to raise_error(ActiveRecord::RecordNotUnique)

      expect(promotion.coupons.reload.size).to eq(1)
    end

  end

  context '#approve!' do

    it  'should generate a PromotionApproval object' do
      creator = User.create!(email: 'rco@gmail.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
        expiration_date: '22/12/2033', user: creator)

      approval_user = User.create!(email: 'julia@gmail.com', password: '654321')

      promotion.approve!(approval_user)

      promotion.reload
      expect(promotion.approved?).to be_truthy
      expect(promotion.approver).to eq approval_user
    end

    it  'should not approve if the same creator user is the approver' do
      creator = User.create!(email: 'rco@gmail.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
        expiration_date: '22/12/2033', user: creator)

      promotion.approve!(creator)

      promotion.reload
      expect(promotion.approved?).to be_falsy
    end
  end

end
