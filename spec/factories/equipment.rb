FactoryBot.define do
  factory :equipment do
    title { "MyString" }
    body { "MyText" }
    lower_limit_temp { 1 }
    max_elevation { 1 }
    image { "MyString" }
  end
end
