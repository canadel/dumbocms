require File.dirname(__FILE__) + '/../../test_helper'
require 'time'

class Liquid::PageTest < ActiveSupport::TestCase
  def setup
    @page = FactoryGirl.create(:page, {
      :permalinks => '/%slug%',
      :name => "Page name",
      :description => "Page description",
      :title => "Page title",
      :latitude => 40.714728,
      :longitude => -73.998672,
    })
    
    @domain = FactoryGirl.create(:domain, {
      :page => @page,
      :name => 'domain.de'
    })
    
    3.times do |n|
      @page.documents << FactoryGirl.create(:document, {
        :page => @page,
        :title => "Example document #{n+1}",
        :slug => "example-document-#{n+1}",
        :published_at => n.hours.ago
      })
    end

    @page.documents << FactoryGirl.create(:document, {
      :page => @page,
      :title => "Frontpage title",
      :slug => 'frontpage',
      :published_at => 2.minutes.ago,
    })
    
    3.times do |n|
      @page.categories << FactoryGirl.create(:category, {
        :name => "Kategory #{n+1}",
        :page => @page
      })
    end
    
    3.times do |n|
      @page.resources << FactoryGirl.create(:resource, {
        :name => "resource#{n+1}.jpg",
        :slug => "resource#{n+1}-jpg",
        :company => @page.company
      })
    end
    
    @document = @page.documents.first
    @document.update_attributes({
      :template => FactoryGirl.create(:template, :account => @page.account)
    })
    
    @page.save!
  end
  
  test('page') do
    assert_liquid 'page', @document
  end
  
  # TODO blank values
end