require 'rails_helper'

RSpec.describe 'Outfits', type: :system do
  describe '一覧ページ' do
    let!(:outfit_15_1500) { create(:outfit, :temp_15, :max_1500, :img_summer) }
    let!(:outfit_25_1500) { create(:outfit, :temp_25, :max_1500, :img_summer) }
    let!(:outfit_15_2500) { create(:outfit, :temp_15, :max_2500, :img_spring) }
    let!(:outfit_25_2500) { create(:outfit, :temp_25, :max_2500, :img_spring) }
    let!(:outfit_15_3800) { create(:outfit, :temp_15, :max_3800, :img_winter) }
    let!(:outfit_25_3800) { create(:outfit, :temp_25, :max_3800, :img_winter) }

    before { visit outfits_path }

    context '一覧ページへアクセス' do
      it '正常に表示される' do
        expect(page).to have_current_path outfits_path, ignore_query: true
        expect(page).to have_content '服装一覧'
        expect(page).to have_content '標高と気温から服装パターンを表示しています。'
        expect(all('.card').count).to eq 6
      end
    end

    context 'ヘッダーリンク' do
      it '「Find Mts」をクリックするとトップページへ遷移する' do
        within('#mainNav') do
          click_link 'Find Mts'
        end
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it '「山を探す」をクリックするとトップページへ遷移する' do
        within('#mainNav') do
          click_link '山を探す'
        end
        expect(page).to have_current_path root_path, ignore_query: true
      end

      it '「山一覧」をクリックすると山一覧ページへ遷移する' do
        within('#mainNav') do
          click_link '山一覧'
        end
        expect(page).to have_current_path mountains_path, ignore_query: true
      end
    end

    context '服装の一覧' do
      it '正常に表示される' do
        expect(page).to have_selector 'img.img-fluid'
        expect(page).to have_content outfit_15_1500.title
        expect(page).to have_content outfit_15_1500.inner.upcase
        expect(page).to have_content outfit_15_1500.outer.upcase
        expect(page).to have_content outfit_15_1500.pant.upcase
        expect(all('.card').count).to eq 6
      end
    end
  end
end
