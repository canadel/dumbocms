require File.dirname(__FILE__) + '/../test_helper'

class TemplateTest < ActiveSupport::TestCase
  def setup
    # Ensure we do not create mess everywhere.
    @templates_path = File.expand_path('../../tmp/templates/', __FILE__)
    @templates_path = "#{@templates_path}/" # FIXME
    Rails.configuration.dumbocms.templates_path = @templates_path
    
    # Ensure that the directory exists.
    Dir.mkdir(@templates_path) unless File.exists?(@templates_path)

    @template = FactoryGirl.build(:template)
  end
  
  test("should create") { FactoryGirl.create(:template) }
  test("to_s") { assert_equal @template.name, @template.to_s }

  # Ensure that templates do not require content. 
  test("content blank") do
    assert FactoryGirl.build(:template, { :content => nil }).valid?
  end
  
  # Ensure that templates are unique within an account
  test("name unique scope") do
    a0, a1 = FactoryGirl.create_list(:account, 2)
    t0, t1 = FactoryGirl.create_list(:template, 2)
    
    t0.update_attributes({ :account_id => a0.id, :name => 'name' })
    t1.update_attributes({ :account_id => a1.id, :name => 'name' })
    
    assert(t0.valid?, 'Should be valid.')
    assert(t1.valid?, 'Both should be valid.')
  end
  
  # Ensure sync_at is set.
  test("synced_at") do
    assert ! FactoryGirl.create(:template).synced_at.nil?
  end
  
  test('json') do
    tmpl = FactoryGirl.create(:template)
    columns = %w{account_id name content}
    assert_equal columns.sort, JSON.parse(tmpl.to_json).keys.sort
  end
end
