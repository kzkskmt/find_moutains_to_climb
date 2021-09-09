class Post < ApplicationRecord
  belongs_to :user
  belongs_to :mountain
  has_many :likes, dependent: :destroy

  enum course_time: { few_hours: 0, over_five_hours: 1, over_eight_hours: 2, all_day_long: 3 }
  enum review: { bad: 0, okay: 1, good: 2, very_good: 3 }
  enum level: { easy: 0, normal: 1, hard: 2 }
  enum physical_strength: { no_sweat: 0, fine: 1, exhausted: 2 }

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 1_000 }
  validates :climbed_on, presence: true
  validates :course_time, presence: true
  validates :review, presence: true
  validates :level, presence: true
  validates :physical_strength, presence: true

  validate :climebd_on_must_be_in_the_past
  
  # 登山日のチェックメソッド
  def climebd_on_must_be_in_the_past
    # 登山日入力済、かつ未来もしくは現在の日付
    if climbed_on.present? && !climbed_on.past?
      # エラー対象属性とエラーメッセージを設定
      errors.add(:climbed_on, :invalid_date)
    end
  end
end
