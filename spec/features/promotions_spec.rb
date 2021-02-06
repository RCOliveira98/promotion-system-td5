require 'rails_helper'

feature 'Admin registers a promotion' do
  scenario 'from index page' do
    visit root_path
    click_on 'Promoções'

    expect(page).to have_link('Registrar uma promoção',
                              href: new_promotion_path)
  end

  scenario 'successfully' do
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'

    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar promoção'

    expect(current_path).to eq(promotion_path(Promotion.last))
    expect(page).to have_content('Cyber Monday')
    expect(page).to have_content('Promoção de Cyber Monday')
    expect(page).to have_content('15,00%')
    expect(page).to have_content('CYBER15')
    expect(page).to have_content('22/12/2033')
    expect(page).to have_content('90')
    expect(page).to have_link('Voltar')
  end

end

feature 'Admin registers a valid promotion' do
    scenario 'and attributes cannot be blank' do
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033')
  
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
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033')
  
      visit root_path
      click_on 'Promoções'
      click_on 'Registrar uma promoção'
      fill_in 'Código', with: 'NATAL10'
      click_on 'Criar promoção'
  
      expect(page).to have_content('já está em uso')
    end
end

feature 'Admin update a promotion' do
  scenario 'and attributes cannot be blank' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
      expiration_date: '22/12/2033')
    
    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar'

    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''

    click_on 'Atualizar'

    expect(page).to have_content('não pode ficar em branco', count: 5)
  end

  scenario 'and code must be unique' do
    Promotion.create!(name: 'SuperShow', description: 'Promoção superShow',
      code: 'SUPSHOW20', discount_rate: 30, coupon_quantity: 15,
      expiration_date: '22/12/2033')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar'

    fill_in 'Código', with: 'SUPSHOW20'
    click_on 'Atualizar'

    expect(page).to have_content('já está em uso')
  end

  scenario 'success' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Editar'

    fill_in 'Código', with: 'NATAL2021'
    click_on 'Atualizar'

    expect(page).to have_content('Promoção atualizada com sucesso!')
  end
end

feature 'Admin delete a promotion' do
  scenario 'success without coupons' do
    promotion = Promotion.create!(name: 'SuperShow', description: 'Promoção superShow',
      code: 'SupShow20', discount_rate: 30, coupon_quantity: 15,
      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Apagar'
    expect(page).to have_no_content('SupShow20')
  end

  scenario 'success with coupons' do
    promotion = Promotion.create!(name: 'SuperShow', description: 'Promoção superShow',
      code: 'SupShow20', discount_rate: 30, coupon_quantity: 15,
      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on promotion.name
    click_on 'Gerar cupons'
    click_on 'Apagar'
    expect(page).to have_no_content('SupShow20')
  end
end
