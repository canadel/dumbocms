ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'facets/string'

class ActiveSupport::TestCase
  
  protected
    def assert_liquid(name, document=nil)
      document ||= FactoryGirl.create(:document)
    
      assets_path = File.expand_path('../assets/', __FILE__)
      
      liquid = File.join(assets_path, [name, '.liquid'].join)
      expected = File.join(assets_path, [name, '.html'].join)
    
      template = document.template
      template.update_attributes(:content => File.read(liquid))
    
      liquid = document.reload.render_fresh.first.cleanlines.to_a.compact.reject(&:blank?).map(&:strip)
      html = File.read(expected).cleanlines.to_a.compact.reject(&:blank?).map(&:strip)
      assert_equal html, liquid, html - liquid
    end
end
