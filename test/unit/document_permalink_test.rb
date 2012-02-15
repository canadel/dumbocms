require File.expand_path('../../test_helper', __FILE__)

class DocumentPermalinkTest < ActiveSupport::TestCase
  def setup
    @stub = build(:document)
    @document = create(:document)
  end

  # test "should permalink before create" do
  #   assert @stub.permalinks.any?
  # end

  test "should permalink after create" do
    assert @document.permalinks.any?
  end
  
  test "should permalink date" do
    @document.external_id = 69
    @document.published_at = "May 1, 2010".to_datetime
    @document.page.permalinks = '/%year%/%month%/%day%/%id%'
    @document.permalink!
    
    assert_equal '/2010/05/01/69', @document.path
  end
  
  test "should permalink id" do
    @document.external_id = 44
    @document.page.permalinks = '/node/%id%'
    @document.permalink!
    
    assert_equal '/node/44', @document.path
  end
  
  test "should permalink language" do
    @document.language = 'en'
    @document.external_id = 44
    @document.page.permalinks = '/%language%/%id%'
    @document.permalink!
    
    assert_equal '/en/44', @document.path
  end
  
  test "should permalink frontpage" do
    @document.slug = 'frontpage'
    @document.external_id = 44
    @document.page.permalinks = '/node/%id%'
    @document.permalink!
    
    assert_equal '/', @document.path
  end
  
  test "should permalink without multiple slashes" do
    @document.slug = 'i-like-myself'
    @document.language = nil
    @document.page.permalinks = '/////%language%/%slug%'
    @document.permalink!
    
    assert_equal '/i-like-myself', @document.path
  end

  test "should permalink with nil tags" do
    @document.slug = 'i-like-myself'
    @document.language = nil
    @document.page.permalinks = '/%language%/%slug%'
    @document.permalink!
    
    assert_equal '/i-like-myself', @document.path
  end
  test "permalink no category" do
    @document.update_attribute(:slug, 'wall-street')
    @document.page.update_attribute(:permalinks, '/%category%/%slug%')
    @document.permalink!
    assert_equal '/wall-street', @document.reload.path
  end
  
  test "should not permalink 404" do
    # Set up fixtures.
    @document.update_attribute(:slug, Document.not_found_slug)
    
    # Fire.
    @document.permalink!
    
    # Check the fire.
    assert @document.path.nil?
    assert_equal 0, @document.permalinks.size
  end
end
