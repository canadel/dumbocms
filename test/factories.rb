FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
  
  sequence :name do |n|
    "name#{n}"
  end
  
  sequence :slug do |n|
    "slug#{n.to_s}"
  end
  
  sequence :domain do |n|
    "#{n}.tanieloty.pl"
  end
  
  factory :plan do
    name
  end

  factory :company do
    name
    plan
  end
  
  factory :account do
    company
    name  'maurycy'
    email
  end
  
  factory :page do
    name
    account
    default_language 'de' # FIXME remove this stupid crap
    permalinks '/%category%/%slug%'
    template
  end
  
  factory :domain do
    page # FIXME ???
    name { Factory.next(:domain) }
  end
  
  factory :template do
    name
    content "hll,crlwrld"
    account # FIXME: duplication with page!
  end
  
  factory :document do
    page
    slug
    content "hll,crlwrld"
    language 'en'
    published_at { 5.days.ago }
    title { Factory.next(:name) } # FIXME: title v name
  end
  
  factory :permalink do
    path '/'
    document
  end
  
  factory :bulk_import do
    account
    record 'domain'
  end
  
  factory(:rewriter) do
    account
    pattern '^ +'
    replacement ' '
  end
  
  factory(:snippet) do
    page
    slug
  end
  
  factory(:category) do
    page
    name
    slug
  end
  
  factory(:resource) do
    company
    name 'logo.jpg'
    slug 'logo'
    resource { File.open(File.join(Rails.root, 'test/assets/logo.jpg')) }
  end
end