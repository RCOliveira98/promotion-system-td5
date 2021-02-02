require 'rails_helper'

describe ProductCategory, type: :model do
  context 'validations' do

    it do
      should validate_presence_of(:name).with_message('não pode ficar em branco')
      should validate_presence_of(:code).with_message('não pode ficar em branco') 
    end
    
    it { should validate_uniqueness_of(:code).with_message('já está em uso') }
  end
end
