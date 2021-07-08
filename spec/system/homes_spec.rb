require 'rails_helper'

RSpec.describe "Homes", type: :system do
  describe 'トップページ' do
    context 'トップページへアクセス' do
      it '正常に表示される' do
        visit root_path
        expect(page).to have_content '登りたい山がみつかるサービス'
        expect(current_path).to eq root_path
      end
    end

    context '地図の表示', js: true do
      it 'GoogleMapが正常に表示される' do
        visit root_path
        within('.gm-style') do
          expect(page).to have_selector("iframe")
        end
      end

      it 'マーカーをクリックするとinWindowが表示される' do
      end
    end
  end
end
