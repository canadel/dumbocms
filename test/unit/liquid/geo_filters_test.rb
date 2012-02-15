require File.dirname(__FILE__) + '/../../test_helper'

class Liquid::GeoFiltersTest < ActiveSupport::TestCase
  def setup
    @doc = FactoryGirl.create(:document)
    @tmpl = @doc.document_template
  end
  
  test('gmaps_staticmap string') do
    @tmpl.content = "{{ '40.714728,-73.998672' | gmaps_staticmap: 12 }}"
    @tmpl.save!
    expected = "http://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=300x300"
    assert_equal expected, @doc.reload.render_fresh.first
  end
  test('gmaps_staticmap document') do
    @doc.update_attributes({
      :latitude => 40.714728,
      :longitude => -73.998672
    })
    @doc.save!
    assert @doc.geo?
    @tmpl.content = "{{ document | gmaps_staticmap: 12 }}"
    @tmpl.save!
    expected = "http://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=300x300"
    assert_equal expected, @doc.reload.render_fresh.first
  end
  test('gmaps_staticmap page') do
    @doc.page.update_attributes({
      :latitude => 40.714728,
      :longitude => -73.998672
    })
    @tmpl.content = "{{ page | gmaps_staticmap: 12 }}"
    @tmpl.save!
    expected = "http://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=300x300"
    assert_equal expected, @doc.reload.render_fresh.first
  end
  
  test('gmaps_embed string') do
    @tmpl.content = "{{ '40.714728,-73.998672' | gmaps_embed: 12 }}"
    @tmpl.save!
    expected = "<iframe width=\"300\" height=\"300\" frameborder=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\" src=\"http://maps.google.com/?ie=UTF8&amp;ll=40.714728,-73.998672&amp;spn=40.714728,-73.998672&amp;t=h&amp;z=12&amp;vpsrc=0&amp;output=embed\"></iframe><br /><small><a href=\"http://maps.google.com/?ie=UTF8&amp;ll=40.714728,-73.998672&amp;spn=40.714728,-73.998672&amp;t=h&amp;z=12&amp;vpsrc=0&amp;source=embed\" style=\"color:#0000FF;text-align:left\">View Larger Map</a></small>"
    assert_equal expected, @doc.reload.render_fresh.first
  end
  test('gmaps_embed document') do
    @doc.update_attributes({
      :latitude => 40.714728,
      :longitude => -73.998672
    })
    @doc.save!
    assert @doc.geo?
    @tmpl.content = "{{ document | gmaps_embed: 12 }}"
    @tmpl.save!
    expected = "<iframe width=\"300\" height=\"300\" frameborder=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\" src=\"http://maps.google.com/?ie=UTF8&amp;ll=40.714728,-73.998672&amp;spn=40.714728,-73.998672&amp;t=h&amp;z=12&amp;vpsrc=0&amp;output=embed\"></iframe><br /><small><a href=\"http://maps.google.com/?ie=UTF8&amp;ll=40.714728,-73.998672&amp;spn=40.714728,-73.998672&amp;t=h&amp;z=12&amp;vpsrc=0&amp;source=embed\" style=\"color:#0000FF;text-align:left\">View Larger Map</a></small>"
    assert_equal expected, @doc.reload.render_fresh.first
  end
  test('gmaps_embed page') do
    @doc.page.update_attributes({
      :latitude => 40.714728,
      :longitude => -73.998672
    })
    @tmpl.content = "{{ page | gmaps_embed: 12 }}"
    @tmpl.save!
    expected = "<iframe width=\"300\" height=\"300\" frameborder=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\" src=\"http://maps.google.com/?ie=UTF8&amp;ll=40.714728,-73.998672&amp;spn=40.714728,-73.998672&amp;t=h&amp;z=12&amp;vpsrc=0&amp;output=embed\"></iframe><br /><small><a href=\"http://maps.google.com/?ie=UTF8&amp;ll=40.714728,-73.998672&amp;spn=40.714728,-73.998672&amp;t=h&amp;z=12&amp;vpsrc=0&amp;source=embed\" style=\"color:#0000FF;text-align:left\">View Larger Map</a></small>"
    assert_equal expected, @doc.reload.render_fresh.first
  end
end
