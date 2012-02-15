require File.expand_path('../../test_helper', __FILE__)

class DocumentLiquidTest < ActiveSupport::TestCase
  def setup
    @stub = build(:document)
    @document = create(:document)
  end
  
  test("assigns") do
    assert_equal ['document', 'page'], @stub.assigns.keys
  end
  test("keys") do
    #--
    # FIXME set permalinks before
    #
    # This is a subtle bug.  We should not create the permalinks before,
    # but, instead, we should do them after, so there's only one single
    # atomic operation.
    #++
    attrs = %w{
      id slug title content description url language published_at category
      categories longitude latitude kind
    }
    
    assert_equal attrs.sort, @document.to_liquid.keys.sort
  end
  test("external_id") do
    assert_equal @document.external_id, @document.to_liquid["id"]
  end
end
