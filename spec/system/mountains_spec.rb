require 'rails_helper'

RSpec.describe "Mountains", type: :system do
  let(:mountain) { create :mountain }

  describe '詳細ページ' do
    context '詳細ページへアクセス' do
      it '正常に表示される' do
        visit mountain_path(mountain.id)
        expect(page).to have_content mountain.name
        expect(current_path).to eq mountain_path(mountain.id)
      end
    end

    context '天気の表示', js: true do
      it 'OpenWeathermapが正常に表示される' do
        visit mountain_path(mountain.id)
        within('.weather-section') do
          expect(page).to have_selector ".weather-report"
          expect(page).to have_content "最高"
        end
      end
    end
  end
end
