require 'rails_helper'

feature 'admin search coupon by id' do
  scenario 'Success' do
    creator = User.create!(email: 'rco@gmail.com', password: '123456')

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
    expiration_date: '22/12/2033', user: creator)

    Promotion.create!(name: 'Dias das crianças', description: 'Promoção do dia das crianças',
      code: '"DCRIANCAS2O21"', discount_rate: 20, coupon_quantity: 50,
      expiration_date: '22/12/2033', user: creator)

    promotion.generate_coupons!
    promotion.reload
    coupon = promotion.coupons.last

    login_as(creator, scope: :user)
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    fill_in 'Pesquisa:', with: coupon.id
    click_on 'Pesquisar'

    expect(current_path).to eq promotion_search_coupons_path(promotion.id)
    expect(page).to have_content(coupon.id)
    expect(page).to have_content(coupon.code)
    expect(page).to have_content(coupon.promotion.name)
    expect(page).to have_content(coupon.promotion.code)

    expect(page).not_to have_content("DCRIANCAS2O21")
  end

  scenario 'coupon not found' do
    creator = User.create!(email: 'rco@gmail.com', password: '123456')

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
    expiration_date: '22/12/2033', user: creator)

    promotion.generate_coupons!
    promotion.reload
    coupon = promotion.coupons.last

    login_as(creator, scope: :user)
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    fill_in 'Pesquisa:', with: coupon.id + 1
    click_on 'Pesquisar'

    # expect(current_path).to eq promotion_search_coupons_path(promotion.id)
    expect(page).to have_content("Não foi encontrado nenhum cupom com id de 101")
  end
end