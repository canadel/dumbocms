FactoryGirl.define do
  factory :document do
    page
    slug
    content "hll,crlwrld"
    language 'en'
    published_at { 5.days.ago }
    title { Factory.next(:name) } # FIXME: title v name
  end
end