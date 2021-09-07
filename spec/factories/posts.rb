FactoryBot.define do
  factory :post do
    title { "MyString" }
    body { "MyText" }
    user { nil }
    mountain { nil }
  end
end
