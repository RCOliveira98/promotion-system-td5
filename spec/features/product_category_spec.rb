require 'rails_helper'

feature 'Admin registers a valid product category' do
    scenario 'and attributes cannot be blank' do
        ProductCategory.create!(name: 'Veículos', code: 'vcl')

        visit root_path
        click_on 'Categorias de produto'
        click_on 'Registrar uma categoria de produto'
        fill_in 'Nome', with: ''
        fill_in 'Código', with: ''
  
        click_on 'Criar'

        expect(page).to have_content('não pode ficar em branco', count: 2)
    end

    scenario 'and code must be unique' do
        ProductCategory.create!(name: 'Roupas', code: 'rp')
    
        visit root_path
        click_on 'Categorias de produto'
        click_on 'Registrar uma categoria de produto'
        fill_in 'Código', with: 'rp'
        click_on 'Criar'
    
        expect(page).to have_content('já está em uso')
    end
end

feature 'Admin register product category' do
    scenario 'and attributes cannot be blank' do
        ProductCategory.create!(name: 'Veículos', code: 'vcl')
        ProductCategory.create!(name: 'Roupas', code: 'rp')

        visit root_path
        click_on 'Categorias de produto'
        click_on 'Roupas'

        fill_in 'Nome', with: ''
        fill_in 'Código', with: ''
  
        click_on 'Atualizar'

        expect(page).to have_content('não pode ficar em branco', count: 2)
    end

    scenario 'and code must be unique' do
        ProductCategory.create!(name: 'Veículos', code: 'vcl')
        ProductCategory.create!(name: 'Roupas', code: 'rp')

        visit root_path
        click_on 'Categorias de produto'
        click_on 'Roupas'

        fill_in 'Código', with: 'vcl'
  
        click_on 'Atualizar'

        expect(page).to have_content('já está em uso')
    end
end