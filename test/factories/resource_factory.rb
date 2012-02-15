FactoryGirl.define do
  factory :resource do
    company
    name 'logo.jpg'
    slug 'logo'
    resource { File.open(File.join(Rails.root, 'test/assets/logo.jpg')) }
  end
end