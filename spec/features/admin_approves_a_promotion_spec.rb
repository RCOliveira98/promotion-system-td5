require 'rails_helper'

feature 'Admin approves a promotion' do
    scenario 'must to be signid in' do
    end

    scenario 'must not be the promotion creator' do
        creator = User.create!(email: 'rco@gmail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
            code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
            expiration_date: '22/12/2033', user: creator)

        other_user = User.create!(email: 'rco2@gmail.com', password: '123456')

        login_as(creator, scope: :user)
        visit promotion_path(promotion)

        expect(page).not_to have_link('Aprovar promoção')
    end

    scenario 'must be the another user' do
        creator = User.create!(email: 'rco@gmail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
            code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
            expiration_date: '22/12/2033', user: creator)

        other_user = User.create!(email: 'rco2@gmail.com', password: '123456')

        login_as(other_user, scope: :user)
        visit promotion_path(promotion)

        expect(page).to have_link('Aprovar promoção')
    end

    scenario 'Successfully' do
        creator = User.create!(email: 'rco@gmail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
            code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
            expiration_date: '22/12/2033', user: creator)

        approval_user = User.create!(email: 'rco2@gmail.com', password: '123456')

        login_as(approval_user, scope: :user)
        visit promotion_path(promotion)

        click_on 'Aprovar promoção'

        promotion.reload
        expect(current_path).to eq promotion_path(promotion)
        expect(promotion.approved?).to be_truthy  
        expect(promotion.approver).to eq approval_user
        expect(page).to have_content('Promoção aprovada!')
    end

end