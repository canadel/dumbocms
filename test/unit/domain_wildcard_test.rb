require 'test_helper'

class DomainWilcardTest < ActiveSupport::TestCase
  def setup
    @domain = FactoryGirl.create(:domain)
  end

  test('setup') do
    assert @domain.wildcard?
  end
  test('default') do
    assert FactoryGirl.build(:domain).wildcard?
  end
  
  test('wildcard wildcard') do
    dom = Domain.matching_wildcard("www.#{@domain.name}")
    
    assert_not_equal @domain, dom
    assert !dom.preferred?
    assert_equal "www.#{@domain.name}", dom.name
    assert_equal @domain.page, dom.page
  end
  test('wildcard exact') do
    assert_equal @domain, Domain.matching_wildcard(@domain.name)
  end
  test('exact wildcard') do
    @domain.update_attribute(:wildcard, false)
    assert_equal nil, Domain.matching_wildcard("www.#{@domain.name}")
  end
  test('exact excact') do
    @domain.update_attribute(:wildcard, false)
    assert_equal @domain, Domain.matching_wildcard(@domain.name)
  end
  
  test('exact first') do
    d0 = FactoryGirl.create(:domain, :name => 'a.pl')
    d1 = FactoryGirl.create(:domain, :name => 'www.a.pl', :wildcard => false)
    
    assert_equal d1, Domain.matching_wildcard('www.a.pl')
  end
end
