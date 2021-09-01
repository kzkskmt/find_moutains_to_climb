require 'rails_helper'

RSpec.describe 'Mountains', type: :system do
  let!(:outfit_15_1500) { create :outfit, :temp_15, :max_1500, :img_summer }
  let!(:outfit_25_1500) { create :outfit, :temp_25, :max_1500, :img_summer }
  let!(:outfit_15_2500) { create :outfit, :temp_15, :max_2500, :img_spring }
  let!(:outfit_25_2500) { create :outfit, :temp_25, :max_2500, :img_spring }
  let!(:outfit_15_3800) { create :outfit, :temp_15, :max_3800, :img_winter }
  let!(:outfit_25_3800) { create :outfit, :temp_25, :max_3800, :img_winter }

  describe '一覧ページ' do
    let!(:mountain_1500_in_hokkaido) { create :mountain, :ele_1500, :in_hokkaido }
    let!(:mountain_2500_in_kantou) { create :mountain, :ele_2500, :in_kantou }
    let!(:mountain_3800_in_kyushu) { create :mountain, :ele_3800, :in_kyushu }

    before { visit mountains_path }

    context '一覧ページへアクセス' do
      it '正常に表示される' do
        expect(current_path).to eq mountains_path
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

    context '検索フォーム' do
      it '正常に表示される' do
        expect(page).to have_content 'キーワードから探す'
        within('form.mountain_search') do
          expect(page).to have_selector '.form-control'
        end
      end
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
      it '検索機能(該当なし)' do
        select '大阪府', from: 'q[prefecture_code_eq]'
        click_button '検索'
        expect(page).to have_content '検索条件と一致する結果が見つかりませんでした。'
        expect(current_path).to eq mountains_path
      end
    end

    context '山の一覧' do
      it '正常に表示される' do
        within('#index') do
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

    context '地図の表示', js: true do
      it 'googlemapが正常に表示される' do
        within('.gm-style') do
          expect(page).to have_selector 'iframe'
        end
      end
    end
  end

  describe '詳細ページ' do
    let!(:mountain) { create :mountain }

    before { visit mountain_path mountain.id }

    context '詳細ページへアクセス' do
      it '正常に表示される' do
        expect(page).to have_content mountain.name
        expect(current_path).to eq mountain_path mountain.id
      end
    end

    context '天気の表示', js: true do
      it 'OpenWeathermapが正常に表示される' do
        within('.weather-section') do
          expect(page).to have_selector '.weather-report'
          expect(page).to have_content '最高'
        end
      end
    end

    context '地図の表示', js: true do
      it 'googlemapが正常に表示される' do
        within('.gm-style') do
          expect(page).to have_selector 'iframe'
        end
      end
    end

    context '写真の表示', js: true do
      it 'googlemapの写真が6枚正常に表示される' do
        within('.gallery-section') do
          expect(page).to have_content 'ギャラリー'
          expect(page).to have_selector 'img.img-fluid'
          expect(all('img.img-fluid').count).to eq 6
        end
      end
    end

    context '服装の表示', js: true do
      it '服装と一覧ページへのリンクが表示される' do
        within('#outfit') do
          expect(page).to have_content 'もし、明日登山するなら'
          expect(page).to have_selector 'img.img-fluid'
          expect(page).to have_link 'こちら'
        end
      end
    end
  end
end
