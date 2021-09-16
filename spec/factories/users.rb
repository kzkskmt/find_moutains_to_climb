FactoryBot.define do
  factory :user do
    name { 'sample_user' }
    email { 'sample_user@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
