class Post < ApplicationRecord
  belongs_to :user
  belongs_to :mountain

  enum course_time: { few_hours: 0, over_five_hours: 1, over_eight_hours: 2, all_day_long: 3 }
  enum review: { bad: 0, okay: 1, good: 2, very_good: 3 }
  enum level: { easy: 0, normal: 1, hard: 2 }
  enum physical_strength: { no_sweat: 0, fine: 1, exhausted: 2 }

  validates :title, presence: true, length: { maximum: 20 }
  validates :body, presence: true, length: { maximum: 1_000 }
end
