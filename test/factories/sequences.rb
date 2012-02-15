FactoryGirl.define do
  sequence :name do |n|
    "name#{n}"
  end
  
  sequence :slug do |n|
    "slug#{n.to_s}"
  end
end