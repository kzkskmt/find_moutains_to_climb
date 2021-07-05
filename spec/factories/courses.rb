FactoryBot.define do
  factory :course do
    sequence(:name, "course_1")
    ascent_time { 1 }
    descent_time { 2 }
    level { :easy }
    starting_point_lat { 34.7050315 }
    starting_point_lng { 135.4962382 }
    association :mountain
  end
end
