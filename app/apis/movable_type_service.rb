# Copyright (c) 2005 Tobias Luetke
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module MovableTypeStructs
  class ArticleTitle < ActionWebService::Struct
    member :dateCreated,  :time
    member :userid,       :string
    member :postid,       :string
    member :title,        :string
  end

  class CategoryList < ActionWebService::Struct
    member :categoryId,   :string
    member :categoryName, :string
  end

  class CategoryPerPost < ActionWebService::Struct
    member :categoryName, :string
    member :categoryId,   :string
    member :isPrimary,    :bool
  end

  class TextFilter < ActionWebService::Struct
    member :key,    :string
    member :label,  :string
  end

  class TrackBack < ActionWebService::Struct
    member :pingTitle,  :string
    member :pingURL,    :string
    member :pingIP,     :string
  end
end


class MovableTypeApi < ActionWebService::API::Base
  inflect_names false

  api_method :getCategoryList,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string} ],
    :returns => [[MovableTypeStructs::CategoryList]]

  api_method :getPostCategories,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string} ],
    :returns => [[MovableTypeStructs::CategoryPerPost]]

  api_method :getRecentPostTitles,
    :expects => [ {:blogid => :string}, {:username => :string}, {:password => :string}, {:numberOfPosts => :int} ],
    :returns => [[MovableTypeStructs::ArticleTitle]]

  api_method :setPostCategories,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string}, {:categories => [MovableTypeStructs::CategoryPerPost]} ],
    :returns => [:bool]

  api_method :supportedMethods,
    :expects => [],
    :returns => [[:string]]

  api_method :supportedTextFilters,
    :expects => [],
    :returns => [[MovableTypeStructs::TextFilter]]

  api_method :getTrackbackPings,
    :expects => [ {:postid => :string}],
    :returns => [[MovableTypeStructs::TrackBack]]

  api_method :publishPost,
    :expects => [ {:postid => :string}, {:username => :string}, {:password => :string} ],
    :returns => [:bool]
end


class MovableTypeService < DumboWebService
  web_service_api MovableTypeApi

  before_invocation :authenticate_api,
    :except => [
      :getTrackbackPings,
      :supportedMethods,
      :supportedTextFilters
    ]

  # Get list of recent posts.
  def getRecentPostTitles(blogid, username, password, numberOfPosts)
    begin
      this_page.documents.latest.limit(numberOfPosts).map do |doc|
        MovableTypeStructs::ArticleTitle.new(
          :dateCreated => doc.published_at,
          :userid => this_page.account.id.to_s,
          :postid => doc.external_id.to_s,
          :title => doc.title
        )
      end
    rescue Exception => e
      logger.error(e.message)

      # Return failure.
      []
    end
  end

  # Get list of all categories for a page.
  def getCategoryList(blogid, username, password)
    begin
      this_page.categories.map do |category|
        MovableTypeStructs::CategoryList.new({
          :categoryId => category.external_id,
          :categoryName => category.name
        })
      end
    rescue Exception => e
      logger.error(e.message)

      # Return failure.
      []
    end
  end

  # Get post categories.
  def getPostCategories(postid, username, password)
    begin
      doc = this_page.documents.find_by_external_id(postid)
      raise(ActiveRecord::RecordNotFound) if doc.nil?

      doc.categories.map do |cat|
        MovableTypeStructs::CategoryPerPost.new({
          :categoryName => cat.name,
          :categoryId => cat.external_id,
          :isPrimary => cat.primary?(doc)
        })
      end
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      []
    end
  end

  # Set post categories, and return true xor false.
  def setPostCategories(postid, username, password, categories)
    begin
      # Some weblog clients omit either categoryId, or categoryName.
      cats = categories.inject([]) do |ret, c|
        ret << c['categoryName'] if c['categoryName'].present?
        ret << c['categoryId'].to_i if c['categoryId'].present?
        ret
      end
      
      # Some weblog clients omit either categoryId, or categoryName.
      cat = categories.inject([]) do |ret, c|
        if c['isPrimary'] === true
          ret << c['categoryName'] if c['categoryName'].present?
          ret << c['categoryId'].to_i if c['categoryId'].present?
        end
        
        ret
      end
      
      doc = this_page.documents.find_by_external_id(postid)
      raise(ActiveRecord::RecordNotFound) if doc.nil?
      
      this_page.categories.many_matching(cat).tap do |category|
        doc.category = category.first unless category.empty?
      end

      doc.categories = this_page.categories.many_matching(cats)
      doc.save!
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      false
    end
  end

  # Return supported text filters
  # 
  # Right now, it returns an empty array, similarly to WordPress:
  #
  #   The stub mt.supportedTextFilters is a dummy stub function that returns
  #   an empty string.
  #
  # See http://codex.wordpress.org/XML-RPC_Support for more details.
  def supportedTextFilters; []; end
  
  # Return list of supported methods.
  def supportedMethods
    begin
      MovableTypeApi.api_methods.keys.map(&:to_s).sort
    rescue Exception => e
      logger.error(e.message)

      # Return failure.
      []
    end
  end

  # Publish the post, and return true xor false.
  def publishPost(postid, username, password)
    begin
      doc = this_page.documents.find_by_external_id(postid)
      raise(ActiveRecord::RecordNotFound) if doc.nil?
      
      doc.published = true
      doc.save!
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      false
    end
  end
  
  def getTrackbackPings(postid)
    begin
      doc = this_page.documents.find_by_external_id(postid)
      raise(ActiveRecord::RecordNotFound) if doc.nil?
      
      []
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      []
    end
  end
end
