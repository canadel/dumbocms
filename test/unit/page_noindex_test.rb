require File.expand_path('../../test_helper', __FILE__)

class PageNoindexTest < ActiveSupport::TestCase
  def setup
    @pg = create(:page)
    @stub = build(:page)
  end
  
  test("initialize") do
    assert @stub.indexable?
    assert @pg.indexable?
  end
  test("noindex?") do
    @pg.update_attributes(:indexable => false)
    assert @pg.noindex?
  end
  test("development noindex?") do
    Rails.configuration.dumbocms.production = false
    @pg.update_attributes(:indexable => true)
    assert @pg.noindex?
  end
  test("not published noindex?") do
    @pg.update_attributes({
      :published_at => 2.hours.from_now,
      :indexable => true
    })
    assert @pg.noindex?
  end
end