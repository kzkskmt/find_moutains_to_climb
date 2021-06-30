require 'rails_helper'

RSpec.describe "Homes", type: :system do
  describe 'トップページ' do
    context 'トップページへアクセス' do
      it '正常に表示される' do
        visit root_path
        expect(page).to have_content '次はどの山にいこう？'
        expect(current_path).to eq root_path
      end
    end
  end
end
