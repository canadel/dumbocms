require File.expand_path('../../test_helper', __FILE__)

class DomainTest < ActiveSupport::TestCase
  def setup
    @domain = create(:domain)
    @page = @domain.page
  end
  
  test("should create") { create(:domain) }

  # Ensure it matches correct domains.
  test("should match") { assert @domain == Domain.matching(@domain.name) }
  test("should not match") { assert nil == Domain.matching('foo') }

  test('strip name') do
    @domain.update_attribute(:name, " d\n u\r p\t a    ")
    assert_equal 'dupa', @domain.name
  end
  
  test('json') do
    dm = create(:domain)
    columns = %w{page_id wildcard name}
    assert_equal(columns.sort, JSON.parse(dm.to_json).keys.sort)
  end
end
