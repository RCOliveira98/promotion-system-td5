require 'rails_helper'

feature 'Admin inactivate coupon' do

  scenario 'must be signed in' do
    visit root_path
    click_on 'Promoções'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Successfully' do

    user = User.new(email: 'rco@gmail.com', password: '123456')
    login_as(user, scope: :user)


    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
        expiration_date: '22/12/2033', user: user)

    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Inativar'

    expect(page).to have_content("#{coupon.code} (Inativo)")
  end

  scenario 'does not view button' do

    user = User.new(email: 'rco@email.com', password: '123456')
    login_as(user, scope: :user)
  
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
        expiration_date: '22/12/2033', user: user)

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

  end

end