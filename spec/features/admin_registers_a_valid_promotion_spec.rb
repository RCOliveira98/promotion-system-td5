require 'rails_helper'

feature 'Admin registers a valid promotion' do
  scenario 'must be signed in' do
    visit root_path
    click_on 'Promoções'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'and attributes cannot be blank' do
    user = User.create!(email: 'rco@gmail.com', password: '123456')
    login_as(user, scope: :user)

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Criar promoção'

    expect(page).to have_content('não pode ficar em branco', count: 5)
  end

  scenario 'and code must be unique' do
    user = User.create!(email: 'rco@gmail.com', password: '123456')
    login_as(user, scope: :user)

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar promoção'

    expect(page).to have_content('já está em uso')
  end
end

