FactoryGirl.define do
  factory :page do
    name
    account
    default_language 'de' # FIXME remove this stupid crap
    permalinks '/%category%/%slug%'
    template
  end
end