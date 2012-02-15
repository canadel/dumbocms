require File.expand_path('../../test_helper', __FILE__)
require 'action_web_service/test_invoke'

class MtApiTest < ActionController::TestCase
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
  
  test("getRecentPostTitles") do
    docs = create_list(:document, 2, :page => @page)
    a = [@page.id, 'u', 'p', 5]
    ret = invoke_layered :mt, :getRecentPostTitles, *a
    assert ret.is_a?(Array)
    assert_equal 2, ret.size
    # assert_equal docs[0].published_at, ret[0]['dateCreated']
    assert_equal docs[0].title, ret[0]['title']
    assert_equal @account.id.to_s, ret[0]['userid']
    assert_equal docs[0].external_id.to_s, ret[0]['postid']
    # assert_equal docs[1].published_at, ret[1]['dateCreated']
    assert_equal docs[1].title, ret[1]['title']
    assert_equal @account.id.to_s, ret[1]['userid']
    assert_equal docs[1].external_id.to_s, ret[1]['postid']
  end
  test("getRecentPostTitles empty") do
    a = [@page.id, 'u', 'p', 5]
    ret = invoke_layered :mt, :getRecentPostTitles, *a
    assert ret.is_a?(Array)
    assert ret.empty?
  end
  test("getCategoryList") do
    cats = create_list(:category, 2, :page => @page)
    a = [@page.id, 'u', 'p']
    ret = invoke_layered :mt, :getCategoryList, *a
    assert ret.is_a?(Array)
    assert_equal 2, ret.size
    assert_equal cats[0].external_id.to_s, ret[0]['categoryId']
    assert_equal cats[0].name, ret[0]['categoryName']
    assert_equal cats[1].external_id.to_s, ret[1]['categoryId']
    assert_equal cats[1].name, ret[1]['categoryName']
  end
  test("getCategoryList empty") do
    a = [@page.id, 'u', 'p']
    ret = invoke_layered :mt, :getCategoryList, *a
    assert ret.is_a?(Array)
    assert ret.empty?
  end
  test("getCategoryList error") do
    a = [312337, 'u', 'p']
    ret = invoke_layered :mt, :getCategoryList, *a
    assert ret.is_a?(Array)
    assert ret.empty?
  end
  test("setPostCategories") do
    doc = create(:document, :page => @page)
    cats = create_list(:category, 2, :page => @page)
    struct = cats.map do |cat|
      MovableTypeStructs::CategoryPerPost.new({
        :categoryName => cat.name,
        :categoryId => cat.external_id,
        :isPrimary => cat.primary?(doc)
      })
    end
    a = [doc.external_id, 'u', 'p', struct]
    ret = invoke_layered :mt, :setPostCategories, *a
    assert_equal true, ret
    assert_equal cats.map(&:name), doc.reload.categories.names
  end
  test("setPostCategories duplicates") do
    doc = create(:document, :page => @page)
    cats = create_list(:category, 2, :page => @page)
    struct = cats.map do |cat|
      MovableTypeStructs::CategoryPerPost.new({
        :categoryName => cat.name,
        :categoryId => cat.external_id.to_s,
        :isPrimary => cat.primary?(doc)
      })
    end
    a = [doc.external_id, 'u', 'p', (struct * 2).flatten]
    ret = invoke_layered :mt, :setPostCategories, *a
    assert_equal true, ret
    assert_equal cats.map(&:name), doc.reload.categories.names
  end
  test("setPostCategories categoryId") do
    doc = create(:document, :page => @page)
    cats = create_list(:category, 2, :page => @page)
    struct = cats.map do |cat|
      MovableTypeStructs::CategoryPerPost.new({
        :categoryId => cat.external_id.to_s,
        :isPrimary => cat.primary?(doc)
      })
    end
    a = [doc.external_id, 'u', 'p', (struct * 2).flatten]
    ret = invoke_layered :mt, :setPostCategories, *a
    assert_equal true, ret
    assert_equal cats.map(&:name).sort, doc.reload.categories.names.sort
  end
  test("setPostCategories categoryName") do
    doc = create(:document, :page => @page)
    cats = create_list(:category, 2, :page => @page)
    struct = cats.map do |cat|
      MovableTypeStructs::CategoryPerPost.new({
        :categoryName => cat.name,
        :isPrimary => cat.primary?(doc)
      })
    end
    a = [doc.external_id, 'u', 'p', (struct * 2).flatten]
    ret = invoke_layered :mt, :setPostCategories, *a
    assert_equal true, ret
    assert_equal cats.map(&:name).sort, doc.reload.categories.names.sort
  end
  test("setPostCategories empty") do
    doc = create(:document, {
      :page => @page,
      :categories => create_list(:category, 2, :page => @page)
    })
    assert doc.reload.categories.any?
    a = [doc.external_id, 'u', 'p', []]
    ret = invoke_layered :mt, :setPostCategories, *a
    assert_equal true, ret
    assert doc.reload.categories.empty?
  end
  test("setPostCategories categoryId primary") do
    doc = create(:document, :page => @page)
    cats = create_list(:category, 2, :page => @page)
    struct = cats.map do |cat|
      MovableTypeStructs::CategoryPerPost.new({
        :categoryId => cat.external_id.to_s,
        :isPrimary => (cats.first == cat ? true : false)
      })
    end
    a = [doc.external_id, 'u', 'p', (struct * 2).flatten]
    ret = invoke_layered :mt, :setPostCategories, *a
    assert_equal true, ret
    assert_equal cats.first, doc.reload.primary_category
    assert_equal cats.map(&:name).sort, doc.reload.categories.names.sort
  end
  test("setPostCategories error") do
    a = [(2 ** 16 - rand(2 ** 8)), 'u', 'p', []]
    ret = invoke_layered :mt, :setPostCategories, *a
    assert_equal false, ret
  end
  test("getPostCategories") do
    doc = create(:document, {
      :page => @page,
      :categories => create_list(:category, 2, :page => @page)
    })
    assert doc.reload.categories.any?
    a = [doc.external_id, 'u', 'p']
    ret = invoke_layered :mt, :getPostCategories, *a
    assert ret.is_a?(Array)
    assert_equal 2, ret.size
  end
  test("getPostCategories error") do
    a = [(2 ** 16 - rand(2 ** 8)), 'u', 'p']
    ret = invoke_layered :mt, :getPostCategories, *a
    assert ret.is_a?(Array)
    assert ret.empty?
  end
  test("supportedTextFilters") do
    a = []
    ret = invoke_layered :mt, :supportedTextFilters, *a
    assert ret.is_a?(Array)
    assert ret.empty?
  end
  test("supportedMethods") do
    a = []
    ret = invoke_layered :mt, :supportedMethods, *a
    assert ret.is_a?(Array)
    expected = ["getCategoryList",
     "getPostCategories",
     "getRecentPostTitles",
     "getTrackbackPings",
     "publishPost",
     "setPostCategories",
     "supportedMethods",
     "supportedTextFilters"]
    assert_equal expected, ret
  end
  test("publishPost") do
    doc = create(:document, :page => @page, :published => false)
    assert !doc.reload.published?
    a = [doc.external_id, 'u', 'p']
    ret = invoke_layered :mt, :publishPost, *a
    assert ret
    assert doc.reload.published?
  end
  test("publishPost wrong") do
    a = [3123131, 'u', 'p']
    ret = invoke_layered :mt, :publishPost, *a
    assert_equal false, ret
  end
  test("getTrackbackPings") do
    doc = create(:document, :page => @page)
    a = [doc.external_id]
    ret = invoke_layered :mt, :getTrackbackPings, *a
    assert_equal([], ret)
  end
  test("getTrackbackPings error") do
    a = [3123133]
    ret = invoke_layered :mt, :getTrackbackPings, *a
    assert_equal([], ret)
  end
end
