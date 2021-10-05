require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'バリデーション' do
    it 'titleが空欄の場合は無効' do
      post_without_title = build(:post, title: '')
      expect(post_without_title).to be_invalid
      expect(post_without_title.errors[:title]).to eq ['を入力してください']
    end

    it 'titleが21文字以上の場合は無効' do
      post_with_invalid_title = build(:post, title: 'a' * 21)
      expect(post_with_invalid_title).to be_invalid
      expect(post_with_invalid_title.errors[:title]).to eq ['は20文字以内で入力してください']
    end

    it 'bodyが空欄の場合は無効' do
      post_without_body = build(:post, body: '')
      expect(post_without_body).to be_invalid
      expect(post_without_body.errors[:body]).to eq ['を入力してください']
    end

    it 'bodyが21文字以上の場合は無効' do
      post_with_invalid_body = build(:post, body: 'a' * 1001)
      expect(post_with_invalid_body).to be_invalid
      expect(post_with_invalid_body.errors[:body]).to eq ['は1000文字以内で入力してください']
    end

    it 'course_timeが空欄の場合は無効' do
      post_without_course_time = build(:post, course_time: nil)
      expect(post_without_course_time).to be_invalid
      expect(post_without_course_time.errors[:course_time]).to eq ['を入力してください']
    end

    it 'reviewが空欄の場合は無効' do
      post_without_review = build(:post, review: nil)
      expect(post_without_review).to be_invalid
      expect(post_without_review.errors[:review]).to eq ['を入力してください']
    end

    it 'levelが空欄の場合は無効' do
      post_without_level = build(:post, level: nil)
      expect(post_without_level).to be_invalid
      expect(post_without_level.errors[:level]).to eq ['を入力してください']
    end

    it 'physical_strengthが空欄の場合は無効' do
      post_without_physical_strength = build(:post, physical_strength: nil)
      expect(post_without_physical_strength).to be_invalid
      expect(post_without_physical_strength.errors[:physical_strength]).to eq ['を入力してください']
    end

    it 'climbed_onが空欄の場合は無効' do
      post_without_climbed_on = build(:post, climbed_on: nil)
      expect(post_without_climbed_on).to be_invalid
      expect(post_without_climbed_on.errors[:climbed_on]).to eq ['を入力してください']
    end

    it 'climbed_onが未来の日付の場合は無効' do
      post_with_invalid_climbed_on = build(:post, climbed_on: Date.tomorrow)
      expect(post_with_invalid_climbed_on).to be_invalid
      expect(post_with_invalid_climbed_on.errors[:climbed_on]).to eq ['は有効な日付ではありません']
    end
  end
end
