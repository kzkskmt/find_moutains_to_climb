require 'rails_helper'

RSpec.describe "Homes", type: :system do
  describe 'トップページ' do
    before { visit root_path }

    context 'トップページへアクセス' do
      it '正常に表示される' do
        expect(page).to have_content '登りたい山がみつかるサービス'
        expect(page).to have_content '「Find Mts」'
        expect(page).to have_content 'キーワードから探す'
        within('form.mountain_search') do
          expect(page).to have_selector '.form-control'
        end
        expect(page).to have_content 'エリアから探す'
        within('#area') do
          expect(page).to have_link '北海道'
          expect(page).to have_link '九　州'
          expect(all('#area-item').count).to eq 8
        end
        expect(page).to have_content '地図から探す'
        expect(page).to have_content '話題の山'
        expect(current_path).to eq root_path
      end
    end

    context '地図の表示', js: true do
      it 'GoogleMapが正常に表示される' do
        within('.gm-style') do
          expect(page).to have_selector("iframe")
        end
      end
    end

    context 'ヘッダーリンク' do
      it '「Find Mts」をクリックするとトップページへ遷移する' do
        within('#mainNav') do
          click_link 'Find Mts'
        end
        expect(current_path).to eq root_path
      end
      it '「山を探す」をクリックするとトップページへ遷移する' do
        within('#mainNav') do
          click_link '山を探す'
        end
        expect(current_path).to eq root_path
      end
      it '「山一覧」をクリックすると山一覧ページへ遷移する' do
        within('#mainNav') do
          click_link '山一覧'
        end
        expect(current_path).to eq mountains_path
      end
    end
  end

  describe '検索機能とリンク' do
    let!(:mountain_1500_in_hokkaido) { create :mountain, :ele_1500, :in_hokkaido }
    let!(:mountain_2500_in_kantou) { create :mountain, :ele_2500, :in_kantou }
    let!(:mountain_3800_in_kyushu) { create :mountain, :ele_3800, :in_kyushu }
    before { visit root_path }

    context '検索機能' do
      it '検索機能(キーワード検索　完全一致)' do
        fill_in 'q[name_or_name_en_cont]', with: '開聞岳'
        click_button '検索'
        expect(all('#mountain-card').count).to eq 1
        expect(current_path).to eq mountains_path
      end
      it '検索機能(キーワード検索　あいまい検索)' do
        fill_in 'q[name_or_name_en_cont]', with: '岳'
        click_button '検索'
        expect(all('#mountain-card').count).to eq 2
        expect(current_path).to eq mountains_path
      end
      it '検索機能(都道府県検索)' do
        select '山梨県', from: 'q[prefecture_code_eq]'
        click_button '検索'
        expect(all('#mountain-card').count).to eq 1
        expect(current_path).to eq mountains_path
      end
      it '検索機能(エリア検索　該当あり)' do
        within('#area') do
          click_link '北海道'
        end
        expect(all('#mountain-card').count).to eq 1
        expect(current_path).to eq mountains_path
      end
      it '検索機能(エリア検索　該当なし)' do
        within('#area') do
          click_link '関　西'
        end
        expect(all('#mountain-card').count).to eq 0
        expect(page).to have_content '検索条件と一致する結果が見つかりませんでした。'
        expect(current_path).to eq mountains_path
      end
    end

    context '話題の山' do
      let!(:outfit_15_1500) { create :outfit, :temp_15, :max_1500, :img_summer }
      let!(:outfit_25_1500) { create :outfit, :temp_25, :max_1500, :img_summer }
      let!(:outfit_15_2500) { create :outfit, :temp_15, :max_2500, :img_spring }
      let!(:outfit_25_2500) { create :outfit, :temp_25, :max_2500, :img_spring }
      let!(:outfit_15_3800) { create :outfit, :temp_15, :max_3800, :img_winter }
      let!(:outfit_25_3800) { create :outfit, :temp_25, :max_3800, :img_winter }
      before { visit root_path }

      it '正常に表示される' do
        within('#popular-mountain') do
          expect(page).to have_selector 'img.img-fluid'
          expect(page).to have_content mountain_1500_in_hokkaido.name
          expect(page).to have_content mountain_1500_in_hokkaido.pref.name
          expect(page).to have_link mountain_1500_in_hokkaido.name
          expect(page).to have_content mountain_2500_in_kantou.name
          expect(page).to have_content mountain_2500_in_kantou.pref.name
          expect(page).to have_link mountain_2500_in_kantou.name
          expect(page).to have_content mountain_3800_in_kyushu.name
          expect(page).to have_content mountain_3800_in_kyushu.pref.name
          expect(page).to have_link mountain_3800_in_kyushu.name
          expect(all('#mountain-card').count).to eq 3
        end
      end
      it '山の名前をクリックすると詳細ページへ遷移する' do
        click_link mountain_1500_in_hokkaido.name
        expect(current_path).to eq mountain_path mountain_1500_in_hokkaido.id
      end
    end
  end
end
