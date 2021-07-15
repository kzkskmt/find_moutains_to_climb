require 'rails_helper'

RSpec.describe "Courses", type: :system do
  let(:course) { create :course }

  describe '詳細ページ' do
    before do
      visit mountain_course_path(course.mountain, course)
    end 

    context '詳細ページへアクセス' do
      it '正常に表示される' do
        expect(page).to have_content course.name
        expect(current_path).to eq mountain_course_path(course.mountain, course)
      end
    end

    context '検索機能' do

      it '「駐車場」「1km」で検索すると、4件ヒットする', js: true do
        fill_in 'キーワード', with: '駐車場'
        select '1 km', from: '検索範囲'
        click_button '周辺の施設を探す'
        within('.result') do
          expect(page).to have_content '評価:'
          expect(page).to have_content '第一駐車場'
          expect(page).to have_content '駐車場', count: 4
        end
      end

      it '検索結果をクリックすると、infowindowが立ち上がる', js: true do
        fill_in 'キーワード', with: '駐車場'
        select '1 km', from: '検索範囲'
        click_button '周辺の施設を探す'
        click_link '第一駐車場'
        within('.gm-style') do
          expect(page).to have_css "div.infowindow"
          expect(page).to have_content '詳細表示'
          expect(page).to have_content 'ここへ行く'
        end
      end

    end

  end
end
