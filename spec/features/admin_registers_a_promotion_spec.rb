require 'rails_helper'

feature 'Admin registers a promotion' do

  scenario 'must be signed in' do
    visit root_path
    click_on 'Promoções'
    # estou dizendo que é esperado que o path atual seja o path de login de user
    expect(current_path).to eq new_user_session_path
  end

  scenario 'from index page' do
    user = User.create!(email: 'rco@email.com', password: '123456')
    # esse é um método disponibilizado pelo devise. Ele opera como stub.
    # O processo passo a passo para se logar tende a ser custoso em um cenário com alguns testes,  
    # o que não é difícil de acontecer. Então para reduzir tempo se usa uma estratégia de fazer o 
    # aplicativo pensar que o usuário está conectado. Ele injeta uma sessão no navegador que o capybara vai usar.
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'

    expect(page).to have_link('Registrar uma promoção',
                              href: new_promotion_path)
  end

  scenario 'successfully' do
    user = User.create!(email: 'rco@email.com', password: '123456')
    login_as user, scope: :user

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
    expect(page).to have_content('Cadastrada por: rco@email.com')
    expect(page).to have_link('Voltar')
  end
end
