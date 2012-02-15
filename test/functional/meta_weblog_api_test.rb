require File.expand_path('../../test_helper', __FILE__)
require 'action_web_service/test_invoke'

class MetaWeblogApiTest < ActionController::TestCase
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
  
  test("getCategories") do
    category = create(:category, :page => @page)
    args = [@page.id, 'u', 'p']
    ret = invoke_layered :metaWeblog, :getCategories, *args
    assert ret.is_a?(Array)
    assert_equal [category.name], ret
  end
  test("getCategories empty") do
    args = [@page.id, 'u', 'p']
    ret = invoke_layered :metaWeblog, :getCategories, *args
    assert ret.is_a?(Array)
    assert ret.empty?
  end
  test("getPost") do
    doc = create(:document, :page => @page)
    args = [doc.external_id, 'u', 'p']
    ret = invoke_layered :metaWeblog, :getPost, *args
    assert_equal doc.title, ret['title']
    assert_equal doc.content, ret['description']
    assert_equal doc.external_id.to_s, ret['postid']
    assert_equal doc.url, ret['url']
    assert_equal doc.url, ret['link']
    assert_equal doc.url, ret['permaLink']
    assert_equal([], ret['categories'])
    # assert_equal doc.published_at.to_time, ret['dateCreated'].to_time
  end
  test("getPost category") do
    cat = create(:category, :name => 'poo', :page => @page)
    doc = create(:document, :page => @page, :category => cat)
    args = [doc.external_id, 'u', 'p']
    ret = invoke_layered :metaWeblog, :getPost, *args
    assert_equal doc.title, ret['title']
    assert_equal doc.content, ret['description']
    assert_equal doc.external_id.to_s, ret['postid']
    assert_equal doc.url, ret['url']
    assert_equal doc.url, ret['link']
    assert_equal doc.url, ret['permaLink']
    assert_equal ['poo'], ret['categories']
    # assert_equal doc.published_at.to_time, ret['dateCreated'].to_time
  end
  test("getPost categories") do
    cats = create_list(:category, 3, :page => @page)
    doc = create(:document, :page => @page)
    doc.categories = cats
    # TODO: ensure that the primary category is returned first
    expected_categories = [cats.map(&:name)].sort(&:name).flatten
    args = [doc.external_id, 'u', 'p']
    ret = invoke_layered :metaWeblog, :getPost, *args
    assert_equal doc.title, ret['title']
    assert_equal doc.content, ret['description']
    assert_equal doc.external_id.to_s, ret['postid']
    assert_equal doc.url, ret['url']
    assert_equal doc.url, ret['link']
    assert_equal doc.url, ret['permaLink']
    assert_equal expected_categories.sort, ret['categories'].sort
    # assert_equal doc.published_at.to_time, ret['dateCreated'].to_time
  end
  test("getPost error") do
    args = [31337, 'u', 'p']
    ret = invoke_layered :metaWeblog, :getPost, *args
    assert_equal nil.to_s, ret['url']
    assert_equal nil.to_s, ret['link']
    assert_equal nil.to_s, ret['permaLink'] # TODO nil vs nil.to_s
  end
  test("getRecentPosts") do
    docs = create_list(:document, 7, :page => @page)
    expected = @page.reload.documents.latest.limit(5).map(&:title)
    args = [@page.id, 'u', 'p', 5]
    ret = invoke_layered :metaWeblog, :getRecentPosts, *args
    assert ret.is_a?(Array)
    assert_equal 5, ret.size
    assert_equal expected, ret.map {|x| x['title']}
  end
  test("getRecentPosts none") do
    assert @page.documents.empty?
    args = [@page.id, 'u', 'p', 16]
    ret = invoke_layered :metaWeblog, :getRecentPosts, *args
    assert ret.is_a?(Array)
    assert ret.empty?
  end
  test("newPost") do
    struct = MetaWeblogStructs::Article.new.tap do |s|
      s.description = 'alo'
      s.title = 'foo'
    end
    
    args = [@page.id, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :newPost, *args
    doc = Document.find_by_external_id(ret.to_i)
    assert_equal @page.id, doc.page_id
    assert_equal 'foo', doc.title
    assert_equal 'foo', doc.slug
    assert_equal 'alo', doc.content
    assert_equal([], doc.categories)
  end
  test("newPost error") do
    struct = MetaWeblogStructs::Article.new.tap do |s|
    end
    
    args = [@page.id, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :newPost, *args
    assert_equal '', ret
  end
  test("newPost categories") do
    cats = create_list(:category, 3, :page => @page)
    expected_categories = cats.map(&:name)
    struct = MetaWeblogStructs::Article.new.tap do |s|
      s.description = 'alo'
      s.title = 'foo'
      s.categories = expected_categories
    end
    
    args = [@page.id, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :newPost, *args
    doc = Document.find_by_external_id(ret.to_i)
    assert_equal @page.id, doc.page_id
    assert_equal 'foo', doc.title
    assert_equal 'foo', doc.slug
    assert_equal 'alo', doc.content
    assert_equal expected_categories, doc.categories.names
  end
  test("newPost draft") do
    cats = create_list(:category, 3, :page => @page)
    expected_categories = cats.map(&:name)
    struct = MetaWeblogStructs::Article.new.tap do |s|
      s.description = 'alo'
      s.title = 'foo'
      s.categories = expected_categories
    end
    
    args = [@page.id, 'u', 'p', struct, false]
    ret = invoke_layered :metaWeblog, :newPost, *args
    doc = Document.find_by_external_id(ret.to_i)
    assert_equal @page.id, doc.page_id
    assert_equal 'foo', doc.title
    assert_equal 'foo', doc.slug
    assert_equal 'alo', doc.content
    assert_equal expected_categories, doc.categories.names
    assert ! doc.published?
    assert_equal nil, doc.published_at
  end
  test("deletePost") do
    doc = create(:document, :page => @page)
    args = ['foo', doc.external_id, 'u', 'p', true]
    ret = invoke_layered :metaWeblog, :deletePost, *args
    assert_equal true, ret
    assert_nil Document.find_by_id(doc.id)
  end
  test("deletePost error") do
    args = ['foo', 31337, 'u', 'p', true]
    ret = invoke_layered :metaWeblog, :deletePost, *args
    assert_equal false, ret
  end
  test("editPost") do
    doc = create(:document, :page => @page)
    struct = MetaWeblogStructs::Article.new.tap do |s|
      s.description = 'alo'
      s.title = 'foo'
    end
    
    # Do not change the slug on updates.
    expected_slug = doc.slug
    
    args = [doc.external_id, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :editPost, *args
    
    doc.reload
    
    assert_equal @page.id, doc.page_id
    assert_equal 'foo', doc.title
    assert_equal expected_slug, doc.slug
    assert_equal 'alo', doc.content
    assert doc.published?
    assert_equal([], doc.categories.names)
  end
  test("editPost link") do
    doc = create(:document, :page => @page)
    struct = MetaWeblogStructs::Article.new.tap do |s|
      s.description = 'alo'
      s.title = 'foo'
      s.link = '/lunch-is-for-wimps'
    end
    
    # Do not change the slug on updates.
    expected_slug = doc.slug
    
    args = [doc.external_id, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :editPost, *args
    
    doc.reload
    
    assert_equal @page.id, doc.page_id
    assert_equal 'foo', doc.title
    assert_equal expected_slug, doc.slug
    assert_equal 'alo', doc.content
    assert_equal '/lunch-is-for-wimps', doc.path
    assert doc.published?
    assert_equal([], doc.categories.names)
  end
  test("editPost link relative") do
    doc = create(:document, :page => @page)
    struct = MetaWeblogStructs::Article.new.tap do |s|
      s.description = 'alo'
      s.title = 'foo'
      s.link = 'lunch-is-for-wimps'
    end
    
    # Do not change the slug on updates.
    expected_slug = doc.slug
    
    args = [doc.external_id, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :editPost, *args
    
    doc.reload
    
    assert_equal @page.id, doc.page_id
    assert_equal 'foo', doc.title
    assert_equal expected_slug, doc.slug
    assert_equal 'alo', doc.content
    assert_equal '/lunch-is-for-wimps', doc.path
    assert doc.published?
    assert_equal([], doc.categories.names)
  end
  test("editPost link url") do
    doc = create(:document, :page => @page)
    struct = MetaWeblogStructs::Article.new.tap do |s|
      s.description = 'alo'
      s.title = 'foo'
      s.link = 'http://onet.pl/lunch-is-for-wimps'
    end
    
    # Do not change the slug on updates.
    expected_slug = doc.slug
    
    args = [doc.external_id, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :editPost, *args
    
    doc.reload
    
    assert_equal @page.id, doc.page_id
    assert_equal 'foo', doc.title
    assert_equal expected_slug, doc.slug
    assert_equal 'alo', doc.content
    assert_equal '/lunch-is-for-wimps', doc.path
    assert doc.published?
    assert_equal([], doc.categories.names)
  end
  test("editPost categories") do
    categories = create_list(:category, 3, :page => @page)
    doc = create(:document, :page => @page)
    expected_categories = categories.map(&:name)
    
    struct = MetaWeblogStructs::Article.new.tap do |s|
      s.description = 'alo'
      s.title = 'foo'
      s.categories = expected_categories
    end
    
    args = [doc.external_id, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :editPost, *args
    assert_equal true, ret
    
    doc.reload
    
    assert_equal @page.id, doc.page_id
    assert_equal 'foo', doc.title
    assert_equal 'alo', doc.content
    assert doc.published?
    assert_equal(expected_categories, doc.categories.names)
  end
  test("editPost error") do
    struct = MetaWeblogStructs::Article.new
    args = [31337, 'u', 'p', struct, true]
    ret = invoke_layered :metaWeblog, :editPost, *args
    assert_equal false, ret
  end
  test("newMediaObject") do
    a = [@page.id, 'u', 'p', '']
    ret = invoke_layered :metaWeblog, :newMediaObject, *a
    assert_equal({'url' => @page.url}, ret)
  end
end
