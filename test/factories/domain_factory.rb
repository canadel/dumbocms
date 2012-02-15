FactoryGirl.define do
  factory :domain do
    page # FIXME ???
    name { Faker::Internet.domain_name }
  end
end