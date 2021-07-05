require 'rails_helper'

RSpec.describe "Courses", type: :system do
  let(:course) { create :course }

  describe '詳細ページ' do
    context '詳細ページへアクセス' do
      it '正常に表示される' do
        visit mountain_course_path(course.mountain.id)
        expect(page).to have_content '検索結果'
        expect(current_path).to eq mountain_course_path(course.mountain.id)
      end
    end
  end
end
