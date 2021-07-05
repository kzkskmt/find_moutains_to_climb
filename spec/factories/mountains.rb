FactoryBot.define do
  factory :mountain do
    sequence(:name, "mountain_1")
    elevation { 1234 }
    prefecture_code { 1 }
    sequence(:city, "city_1")
    peak_location_lat { 34.8375168 }
    peak_location_lng { 135.4298562 }
  end
end
