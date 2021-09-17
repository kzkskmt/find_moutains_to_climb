FactoryBot.define do
  factory :post do
    sequence(:title, "title_1")
    sequence(:body, "body_1")
    # enumはランダム
    course_time { Post.course_times.keys.sample }
    review { Post.reviews.keys.sample }
    level { Post.levels.keys.sample }
    physical_strength { Post.physical_strengths.keys.sample }
    climbed_on { Date.today }
    association :mountain
    association :user
  end
end
