require File.expand_path('../../../test_helper', __FILE__)

class Liquid::OgpFiltersTest < ActiveSupport::TestCase
  def setup
    @doc = create(:document)
    @pg = @doc.page
    @pg.update_attribute(:ogp, true)
    @dom = create(:domain, :page => @pg)
    @tmpl = @doc.document_template
    
    @document = create(:document, {
      :title => 'document title',
      :kind => 'product',
      :page => @pg,
      :latitude => 52.229676,
      :longitude => 21.012229,
      :template => create(:template)
    })
  end
  test("setup") do
    assert @pg.ogp?
    assert @doc.url
  end
  test('ogp_meta_tags') do
    @tmpl.update_attribute(:content, "{{ document | ogp_meta_tags }}")
    expected = "<meta property=\"og:title\" content=\"#{@doc.to_s}\" />\n<meta property=\"og:type\" content=\"article\" />\n<meta property=\"og:url\" content=\"#{@doc.url}\" />"
    assert_equal expected, @doc.reload.render_fresh.first
  end
  test('ogp_meta_tags empty') do
    @pg.update_attribute(:ogp, false)
    @tmpl.update_attribute(:content, "{{ document | ogp_meta_tags }}")
    assert_equal '', @doc.reload.render_fresh.first
  end
  test('ogp_meta_tags coordinates') do
    @doc.update_attributes({
      :latitude => 52.229676,
      :longitude => 21.012229
    })
    @tmpl.update_attribute(:content, "{{ document | ogp_meta_tags }}")
    expected = "<meta property=\"og:title\" content=\"#{@doc.to_s}\" />\n<meta property=\"og:type\" content=\"article\" />\n<meta property=\"og:url\" content=\"#{@doc.url}\" />\n<meta property=\"og:latitude\" content=\"#{@doc.latitude}\" />\n<meta property=\"og:longitude\" content=\"#{@doc.longitude}\" />"
    assert_equal expected, @doc.reload.render_fresh.first
  end
  
  test('ogp_title') { assert_liquid 'ogp_title', @document }
  test('ogp_type') { assert_liquid 'ogp_type', @document }
  test('ogp_url') { assert_liquid 'ogp_url', @document }
  test('ogp_latitude') { assert_liquid 'ogp_latitude', @document }
  test('ogp_longitude') { assert_liquid 'ogp_longitude', @document }
end
