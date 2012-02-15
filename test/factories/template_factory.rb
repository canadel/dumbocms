FactoryGirl.define do
  factory :template do
    name
    content "hll,crlwrld"
    account # FIXME: duplication with page!
  end
end