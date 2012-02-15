require 'test_helper'

class DocumentMarkupTest < ActiveSupport::TestCase
  def setup
    @doc = FactoryGirl.create(:document)
  end
  
  test("default") do
    assert_equal '', @doc.markup
    assert_equal '', @doc.markup
  end
  test('markdown') do
    @doc.update_attributes({
      :content => '*single asterisks*',
      :markup => 'markdown'
    })
    
    assert @doc.valid?
    assert_equal '<p><em>single asterisks</em></p>', @doc.content_html
  end
  test('textile') do
    @doc.update_attributes({
      :content => '*a phrase*',
      :markup => 'textile'
    })
    
    assert @doc.valid?
    assert_equal '<p><strong>a phrase</strong></p>', @doc.content_html
  end
  test('sanitize') do
    @doc.update_attributes({
      :content => '<a href="http://a.pl/">test</a>',
      :markup => 'sanitize'
    })
    
    assert @doc.valid?
    assert_equal 'test', @doc.content_html
  end
end
