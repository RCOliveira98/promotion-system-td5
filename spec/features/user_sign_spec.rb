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

    xscenario 'sign up' do
        visit root_path
        click_on 'Criar conta'
        within('form') do
            fill_in 'E-mail', with: user.email
            fill_in 'Senha', with: '123456'
            fill_in 'Confirme sua senha', with: '123456'
            
            click_on 'Atualizar'
        end
    end

end