require 'rails_helper'

feature 'User sign in' do

  scenario 'successfully' do

    user = User.create!(email: 'rco@gmail.com', password: '123456')
    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: user.email
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).to have_content user.email
    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_link 'Sair'
  end

  scenario 'and log of' do

    user = User.create!(email: 'rco@gmail.com', password: '123456')
    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: user.email
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    click_on 'Sair'

    within('nav') do
        expect(page).to_not have_content user.email
        expect(page).to_not have_link 'Sair'
        expect(page).to have_link 'Entrar'
    end
  end

  scenario 'invalid e-mail' do

    user = User.create!(email: 'rco@gmail.com', password: '123456')
    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'rco2@gmail.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).not_to have_content user.email
    expect(page).to have_content 'E-mail ou senha inválidos'
    expect(page).not_to have_link 'Sair'
  end

  scenario 'invalid password' do

    user = User.create!(email: 'rco@gmail.com', password: '123456')
    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'rco2@gmail.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).not_to have_content user.email
    expect(page).to have_content 'E-mail ou senha inválidos'
    expect(page).not_to have_link 'Sair'
  end

end

feature 'User sign up' do

  scenario 'successfully' do
      visit root_path
      click_on 'Criar conta'
      within('form') do
        fill_in 'E-mail', with: 'rco@gmail.com'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        
        click_on 'Cadastrar'
      end

      within('nav') do
        expect(page).to have_content 'rco@gmail.com'
        expect(page).to have_link 'Sair'
      end

      expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
  end

  scenario 'attributes cannot be empty' do
    visit root_path
    click_on 'Criar conta'
    within('form') do
      fill_in 'E-mail', with: ''
      fill_in 'Senha', with: ''
      fill_in 'Confirme sua senha', with: ''
      
      click_on 'Cadastrar'
    end

    expect(page).to have_content 'Não foi possível salvar usuário: 2 erros.'
    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
  end

  scenario 'password other than password confirmation' do
    visit root_path
    click_on 'Criar conta'
    within('form') do
      fill_in 'E-mail', with: 'rco@email.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua senha', with: '123455'
      
      click_on 'Cadastrar'
    end

    expect(page).to have_content 'Não foi possível salvar usuário: 1 erro'
    expect(page).to have_content 'Confirme sua senha não é igual a Senha'
  end
  
  scenario 'Password too short' do
    visit root_path
    click_on 'Criar conta'
    within('form') do
      fill_in 'E-mail', with: 'rco@email.com'
      fill_in 'Senha', with: '12345'
      fill_in 'Confirme sua senha', with: '12345'
      
      click_on 'Cadastrar'
    end

    expect(page).to have_content 'Não foi possível salvar usuário: 1 erro'
    expect(page).to have_content 'Senha é muito curto (mínimo: 6 caracteres)'
  end

end