FactoryGirl.define do
  factory :account do
    company
    name  'dumbo'
    email { Faker::Internet.email }
  end
end