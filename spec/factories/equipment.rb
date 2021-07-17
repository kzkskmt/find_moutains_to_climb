FactoryBot.define do
  factory :equipment do
    sequence(:title, "equipment_1")
    sequence(:body, "body_1")
  end

  trait :temp_15 do
    lower_limit_temp { 15 }
  end

  trait :temp_25 do
    lower_limit_temp { 25 }
  end

  trait :elevation_1500 do
    max_elevation { 1500 }
  end

  trait :elevation_2500 do
    max_elevation { 2500 }
  end

  trait :elevation_3800 do
    max_elevation { 3800 }
  end

end
