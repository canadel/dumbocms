require File.expand_path('../../test_helper', __FILE__)
require 'fileutils'

class AccountRepoTemplatesTest < ActiveSupport::TestCase
  
  def setup
    # Sandbox
    @templates_path = File.expand_path('../../tmp/templates/', __FILE__)
    @templates_path = [ @templates_path, '/' ].join # FIXME

    Rails.configuration.dumbocms.templates_path = @templates_path

    # Create the tmp templates dir
    Dir.mkdir(@templates_path) unless File.exists?(@templates_path)

    # Fixtures
    @account = create(:account)
    
    # Template fixtures
    @names = %w{tpl.liquid tpl.html tpl.txt}
    
    @pathes = @names.map {|name| File.expand_path(name, @account.templates_path) }
    @pathes.each do |path|
      File.open(path, 'w') do |f|
        f.write("Hello, world.")
      end
    end
  end
  
  def teardown
    Dir.rmdir(@templates_path) unless File.exists?(@templates_path)
  end
  
  test("setup") do
    assert @account.templates.none?, 'account has templates'
    assert @templates_path.present?, 'no templates path'
    assert File.exists?(@templates_path), 'no templates dir'
  end
  test('after_destroy') do
    @account.sync!
    @account.templates.destroy_all
    
    @pathes.each do |path|
      next unless Template.extensions.include?(File.extname(path))
      
      assert !File.exists?(path), "#{path} exists"
    end
  end
  test('has_many restrict') do
    @account.sync!
    
    @template = @account.templates.first
    @page = create(:page, :template => @template)

    assert_raise(ActiveRecord::DeleteRestrictionError) do
      @template.destroy
    end
    
    assert_raise(ActiveRecord::DeleteRestrictionError) do
      @account.templates.destroy_all
    end
  end
  
  test('create') do
    assert @account.templates.none?
    
    @account.sync!
    
    assert_equal 2, @account.templates.size
    assert_equal %w{tpl.liquid tpl.html}.sort, @account.templates.map(&:name).sort
    assert_equal 1, @account.templates.map(&:content).uniq.size
    assert_equal "Hello, world.", @account.templates.map(&:content).uniq.first
  end
  test('update') do
    @pathes.each do |path|
      File.open(path, 'w') do |f|
        f.write("I love Fall")
      end
    end

    @account.sync!
    
    assert_equal 2, @account.templates.size
    assert_equal %w{tpl.liquid tpl.html}.sort, @account.templates.map(&:name).sort
    assert_equal "I love Fall", @account.templates.map(&:content).uniq.first
  end
  test('destroy') do
    @pathes.each do |path|
      FileUtils.rm_f(path) if File.exists?(path)
    end
    
    @account.sync!
    
    assert @account.templates.none?
  end
end