require 'rails_helper'

feature 'Admin (user) search promotions' do

  scenario 'successfully' do
    creator = User.create!(email: 'rco@gmail.com', password: '123456')

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
      expiration_date: '22/12/2033', user: creator)

    Promotion.create!(name: 'Dia dos namorados', description: 'Promoção do dia dos namorados',
      code: 'D-NAMORADOS2O33', discount_rate: 20, coupon_quantity: 50,
      expiration_date: '22/12/2033', user: creator)

    promotion = Promotion.create!(name: 'Dia das crianças', description: 'Promoção do dia das crianças',
      code: 'D-CRIANCAS2033', discount_rate: 15, coupon_quantity: 80,
      expiration_date: '22/12/2033', user: creator)

    login_as(creator, scope: :user)

    visit root_path
    click_on 'Promoções'
    fill_in 'Buscar:', with: promotion.name
    click_on 'Pesquisar'

    expect(current_path).to eq search_promotions_path

    expect(page).to have_content(promotion.name)
    expect(page).to have_content(promotion.description)

    expect(page).not_to have_content('Dia dos namorados')
    expect(page).not_to have_content('Natal')
  
  end

  scenario 'promotion not found' do
    creator = User.create!(email: 'rco@gmail.com', password: '123456')

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
      expiration_date: '22/12/2033', user: creator)

    Promotion.create!(name: 'Dia dos namorados', description: 'Promoção do dia dos namorados',
      code: 'D-NAMORADOS2O33', discount_rate: 20, coupon_quantity: 50,
      expiration_date: '22/12/2033', user: creator)

    Promotion.create!(name: 'Dia das crianças', description: 'Promoção do dia das crianças',
      code: 'D-CRIANCAS2033', discount_rate: 15, coupon_quantity: 80,
      expiration_date: '22/12/2033', user: creator)

    login_as(creator, scope: :user)

    visit root_path
    click_on 'Promoções'
    fill_in 'Buscar:', with: 'Festa junina'
    click_on 'Pesquisar'

    expect(current_path).to eq search_promotions_path

    expect(page).to have_content('Nenhuma promoção foi encontrada!')

    expect(page).not_to have_content('Festa junina')
  end
end