require 'rails_helper'

feature 'Admin inactivate coupon' do
    scenario 'Successfully' do
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
            code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
            expiration_date: '22/12/2033')

        coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

        visit root_path
        click_on 'Promoções'
        click_on promotion.name
        click_on 'Inativar'

        expect(page).to have_content("#{coupon.code} (Inativo)")
    end

    scenario 'does not view button' do
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
            code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
            expiration_date: '22/12/2033')

        coupon_active = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: :active)

        coupon_inactive = Coupon.create!(code: 'NATAL10-0002', promotion: promotion, status: :inactive)

        visit root_path
        click_on 'Promoções'
        click_on promotion.name

        expect(page).to have_content('NATAL10-0001 (Ativo)')
        expect(page).to have_content('NATAL10-0002 (Inativo)')

        within("tr#coupon_#{coupon_active.id}") do
            expect(page).to have_link 'Inativar'
        end

        within("tr#coupon_#{coupon_inactive.id}") do
            expect(page).not_to have_link 'Inativar'
        end

        # expect(page).to have_css("tr#coupon-#{coupon_active.id}")

    end

end