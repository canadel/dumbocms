FactoryGirl.define do
  factory :rewriter do
    account
    pattern '^ +'
    replacement ' '
  end
end