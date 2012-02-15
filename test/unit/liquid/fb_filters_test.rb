require File.dirname(__FILE__) + '/../../test_helper'

class Liquid::FbFiltersTest < ActiveSupport::TestCase
  def setup
    @doc = FactoryGirl.create(:document)
    @tmpl = @doc.document_template
  end
  
  test('fb_comments') do
    @tmpl.content = "{{ 'http://dumbocms.com/' | fb_comments }}"
    @tmpl.save!
    expected = '<a href="http://dumbocms.com/">Dumbo</a>'
    assert_equal "<div id=\"fb-root\"></div>\n<script>(function(d, s, id) {\n  var js, fjs = d.getElementsByTagName(s)[0];\n  if (d.getElementById(id)) {return;}\n  js = d.createElement(s); js.id = id;\n  js.src = \"//connect.facebook.net/en_US/all.js#xfbml=1\";\n  fjs.parentNode.insertBefore(js, fjs);\n}(document, 'script', 'facebook-jssdk'));</script>\n\n<div class=\"fb-comments\" data-href=\"http://dumbocms.com/\" data-num-posts=\"2\" data-width=\"300\"></div>\n", @doc.reload.render_fresh.first
  end
end
