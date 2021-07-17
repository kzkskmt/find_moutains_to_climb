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

    # context '服装の表示', js: true do
    #   let(:equipment_15_1500) { create :equipment, :temp_15, :elevation_1500 }
    #   let(:equipment_25_1500) { create :equipment, :temp_25, :elevation_1500 }
    #   let(:equipment_15_2500) { create :equipment, :temp_15, :elevation_2500 }
    #   let(:equipment_25_2500) { create :equipment, :temp_25, :elevation_2500 }
    #   let(:equipment_15_3800) { create :equipment, :temp_15, :elevation_3800 }
    #   let(:equipment_25_3800) { create :equipment, :temp_25, :elevation_3800 }

    #   it '気温と標高に適した服装が表示される' do
    #     visit mountain_path(mountain.id)
    #     within('.weather-section') do
    #       expect(page).to have_selector ".weather-report"
    #       expect(page).to have_content "最高"
    #     end
    #   end
    # end
  end
end
