FactoryBot.define do
  factory :outfit do
    sequence(:title, 'outfit_1')
    sequence(:body, 'body_1')
    sequence(:inner, 'inner_1')
    sequence(:outer, 'outer_1')
    sequence(:pant, 'pant_1')
    lower_limit_temp { 15 }
    max_elevation { 1500 }
  end

  trait :outer_bring do
    outer_bring { 'outer_bring_1' }
  end

  trait :temp_15 do
    lower_limit_temp { 15 }
  end

  trait :temp_25 do
    lower_limit_temp { 25 }
  end

  trait :max_1500 do
    max_elevation { 1500 }
  end

  trait :max_2500 do
    max_elevation { 2500 }
  end

  trait :max_3800 do
    max_elevation { 3800 }
  end

  trait :img_summer do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/summer.jpg')) }
    # image { File.new("#{Rails.root}/spec/fixtures/summer.jpg") }
  end

  trait :img_spring do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/spring.jpg')) }
    # image { File.new("#{Rails.root}/spec/fixtures/spring.jpg") }
  end

  trait :img_winter do
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/winter.jpg')) }
    # image { File.new("#{Rails.root}/spec/fixtures/winter.jpg") }
  end
end
