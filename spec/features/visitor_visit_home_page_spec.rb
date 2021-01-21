require 'rails_helper'
# AAA
# Arrange -> setup de dados

feature 'Visitor visit home page' do
  scenario 'successfully' do
    # Act -> Ação para pode testar
    visit root_path
    # Assert
    expect(page).to have_content('Promotion System')
    expect(page).to have_content('Boas vindas ao sistema de gestão de '\
                                 'promoções')
  end
end
