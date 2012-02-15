require 'test_helper'

class DocumentPublishedTest < ActiveSupport::TestCase
  def setup
    @stub = Factory.build(:document)
    @document = FactoryGirl.create(:document)
  end

  test("initialize") do
    assert_not_nil @stub.published_at
  end
  test("create") do
    assert_not_nil @document.published_at
  end
  
  test("nil update_attribute") do
    @document.update_attribute(:published_at, nil)
    @document.reload
    
    assert @document.published_at.nil?
  end
  test("nil update_attributes") do
    @document.update_attributes({ :published_at => nil })
    @document.reload
    
    assert @document.published_at.nil?
  end
  test("nil create") do
    @document = FactoryGirl.create(:document, { :published_at => nil })
    @document.reload
    
    assert @document.published_at.nil?
  end
  test("nil save") do
    assert @stub.id.nil?
    
    @stub.published_at = nil
    @stub.save!
    
    assert @stub.published_at.nil?
  end
  
  test("not nil update_attribute") do
    @document.update_attribute(:published_at, 2.hours.from_now)
    @document.reload
    
    assert @document.published_at > Time.now
  end
  test("not nil update_attributes") do
    @document.update_attributes({ :published_at => 2.hours.from_now })
    @document.reload
    
    assert @document.published_at > Time.now
  end
  test("not nil create") do
    @document = FactoryGirl.create(:document, {
      :published_at => 2.hours.from_now
    })
    @document.reload
    
    assert @document.published_at > Time.now
  end
  test("not nil save") do
    assert @stub.id.nil?
    
    @stub.published_at = 3.hours.from_now
    @stub.save!
    
    assert @stub.published_at > Time.now
  end
  
  test("published true update_attribute") do
    @document.update_attribute(:published, true)
    @document.reload
    
    assert_not_nil @document.published_at
    assert @document.published_at > 3.minutes.ago
    assert @document.published_at < Time.now
  end
  test("published true update_attributes") do
    @document.update_attributes({ :published => true })
    @document.reload
    
    assert_not_nil @document.published_at
    assert @document.published_at > 3.minutes.ago
    assert @document.published_at < Time.now
  end
  test("published true create") do
    @document = FactoryGirl.create(:document, { :published => true })
    @document.reload
    
    assert_not_nil @document.published_at
    assert @document.published_at > 3.minutes.ago
    assert @document.published_at < Time.now
  end
  test("published true save") do
    assert @stub.id.nil? # FIXME test("setup")
    
    @stub.published = true
    @stub.save!
    
    assert_not_nil @stub.published_at
    assert @stub.published_at > 3.minutes.ago
    assert @stub.published_at < Time.now
  end
  
  test("published false update_attribute") do
    @document.update_attribute(:published, false)
    @document.reload
    
    assert @document.published_at.nil?
  end
  test("published false update_attributes") do
    @document.update_attributes({ :published => false })
    @document.reload

    assert @document.published_at.nil?
  end
  test("published false create") do
    @document = FactoryGirl.create(:document, { :published => false })
    @document.reload
    
    assert @document.published_at.nil?
  end
  test("published false save") do
    @stub.published = false
    @stub.save!
    
    assert @stub.published_at.nil?
  end
  
  test("past published?") do
    @stub.published_at = 4.hours.ago
    
    assert @stub.published?
  end
  test("nil published?") do
    @stub.published_at = nil
    
    assert ! @stub.published?
  end
  test("future published?") do
    @stub.published_at = 4.hours.from_now
    
    assert ! @stub.published?
  end
end
