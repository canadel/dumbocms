require File.expand_path('../../test_helper', __FILE__)
require 'action_web_service/test_invoke'

class BloggerApiTest < ActionController::TestCase
  include ActionWebService::TestInvoke::InstanceMethods
  
  def setup
    @controller = BackendController.new
    
    @account = create(:account, {
      :email => 'u',
      :password => 'p',
      :password_confirmation => 'p'
    })
    @domain = create(:domain)
    @page = create(:page, {
      :account => @account,
      :domain => @domain
    })
    @protocol = :xmlrpc
    
    @request.host = @page.preferred_domain.name
  end
  
  test("deletePost") do
    doc = create(:document, :page => @page)
    assert @account.reload.documents.include?(doc)
    assert_not_nil doc.external_id
    args = ['foo', doc.external_id, 'u', 'p', 1]
    ret = invoke_layered :blogger, :deletePost, *args
    assert ! Document.exists?(doc.id)
    assert_equal true, ret
  end
  test("deletePost error") do
    args = ['foo', 69, 'u', 'p', 1]
    ret = invoke_layered :blogger, :deletePost, *args
    assert_equal false, ret
  end
  test("getUserInfo") do
    args = ['foo', 'u', 'p']
    ret = invoke_layered :blogger, :getUserInfo, *args
    assert_equal 'u', ret['nickname'] # FIXME
    assert_equal @page.url, ret['url'] # FIXME
    assert_equal 'dumbo', ret['lastname'] # FIXME
    assert_equal @account.id.to_s, ret['userid']
    assert_equal '', ret['firstname'] # FIXME
    assert_equal 'u', ret['email']
  end
  test("getUsersBlogs") do
    args = ['foo', 'u', 'p']
    ret = invoke_layered :blogger, :getUsersBlogs, *args
    assert ret.is_a?(Array)
    assert ret.any?
    assert_equal 1, ret.size
    assert_equal @page.to_s, ret.first['blogName']
    assert_equal @page.url, ret.first['url']
    assert_equal @page.external_id.to_s, ret.first['blogid']
  end
  test("newPost") do
    args = ['foo', @page.id, 'u', 'p', 'hello, world', true]
    assert_difference('Document.count', 1) do
      ret = invoke_layered :blogger, :newPost, *args
      doc = @page.reload.documents.find_by_external_id(ret.to_i)
      assert doc.published?
      assert doc.title.present? # FIXME
      assert_equal 'hello, world', doc.content
      assert_equal @page.id, doc.page_id
      assert_equal @account.id, doc.author_id
    end
  end
  test("newPost title") do
    content = '<title>hau</title>miau'
    args = ['foo', @page.id, 'u', 'p', content, true]
    assert_difference('Document.count', 1) do
      ret = invoke_layered :blogger, :newPost, *args
      doc = @page.reload.documents.find_by_external_id(ret.to_i)
      assert doc.published?
      assert doc.title.present?
      assert_equal 'hau', doc.slug
      assert_equal 'hau', doc.title
      assert_equal 'miau', doc.content
      assert_equal @page.id, doc.page_id
      assert_equal @account.id, doc.author_id
    end
  end
  test("newPost categories") do
    cats = create_list(:category, 3, :page => @page)
    content = "<title>hau</title><category>#{cats.join(",")}</category>miau"
    args = ['foo', @page.id, 'u', 'p', content, true]
    assert_difference('Document.count', 1) do
      ret = invoke_layered :blogger, :newPost, *args
      doc = @page.reload.documents.find_by_external_id(ret.to_i)
      assert doc.published?
      assert doc.title.present?
      assert_equal 'hau', doc.slug
      assert_equal 'hau', doc.title
      assert_equal 'miau', doc.content
      assert_equal @page.id, doc.page_id
      assert_equal @account.id, doc.author_id
      assert_equal cats.map(&:id).sort, doc.categories.map(&:id).sort
    end
  end
  test("newPost error") do
    args = ['foo', @page.id, 'u', 'p', '', true]
    assert_difference('Document.count', 0) do
      ret = invoke_layered :blogger, :newPost, *args
      assert_equal 0, ret
    end
  end
end
