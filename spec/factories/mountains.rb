FactoryBot.define do
  factory :mountain do
    sequence(:name, "mountain_1")
    elevation { 1234 }
    prefecture_code { 1 }
    sequence(:city, "city_1")
    # 富士山の経度緯度を設定
    peak_location_lat { 35.360626 }
    peak_location_lng { 138.727363 }
  end
end
