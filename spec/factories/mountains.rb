FactoryBot.define do

  factory :mountain do
    sequence(:id, 1)
    sequence(:name, "山_1")
    sequence(:name_en, "mountain_1")
    elevation { 1000 }
    # 開聞岳
    peak_location_lat { 31.1801944 }
    peak_location_lng { 130.5283056 }
    prefecture_code { 46 }
    place_id { 'ChIJQ2hgD6fRPTURsjqOag25w0g' }
    image { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/mountain_img.png')) }
  end

  trait :ele_1500 do
    elevation { 1500 }
  end

  trait :ele_2500 do
    elevation { 2500 }
  end

  trait :ele_3800 do
    elevation { 3800 }
  end

  trait :in_hokkaido do
    name { '幌尻岳' }
    peak_location_lat { 42.7194722 }
    peak_location_lng { 142.6828889 }
    prefecture_code { 1 }
    place_id { 'ChIJOfMzqOxkdF8RXfK9C7S42ZU' }
  end

  trait :in_kantou do
    name { '富士山' }
    peak_location_lat { 35.360626 }
    peak_location_lng { 138.727363 }
    prefecture_code { 19 }
    place_id { 'ChIJmcj9QppiGWAR36TzFsn8oaY' }
  end

  trait :in_kyushu do
    name { '開聞岳' }
    peak_location_lat { 31.1801944 }
    peak_location_lng { 130.5283056 }
    prefecture_code { 46 }
    place_id { 'ChIJQ2hgD6fRPTURsjqOag25w0g' }
  end
end
