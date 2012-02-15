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

require 'tempfile'

module MetaWeblogStructs
  class Article < ActionWebService::Struct
    member :description,        :string
    member :title,              :string
    member :postid,             :string
    member :url,                :string
    member :link,               :string
    member :permaLink,          :string
    member :categories,         [:string]
    member :mt_text_more,       :string
    member :mt_excerpt,         :string
    member :mt_keywords,        :string
    member :mt_allow_comments,  :int
    member :mt_allow_pings,     :int
    member :mt_convert_breaks,  :string
    member :mt_tb_ping_urls,    [:string]
    member :dateCreated,        :time
  end

  class MediaObject < ActionWebService::Struct
    member :bits, :string
    member :name, :string
    member :type, :string
  end

  class Url < ActionWebService::Struct
    member :url, :string
  end
end


class MetaWeblogApi < ActionWebService::API::Base
  inflect_names false

  api_method :getCategories,
    :expects => [
      {:blogid => :string},
      {:username => :string},
      {:password => :string}
    ],
    :returns => [[:string]]

  api_method :getPost,
    :expects => [
      {:postid => :string},
      {:username => :string},
      {:password => :string}
    ],
    :returns => [MetaWeblogStructs::Article]

  api_method :getRecentPosts,
    :expects => [
      {:blogid => :string},
      {:username => :string},
      {:password => :string},
      {:numberOfPosts => :int}
    ],
    :returns => [[MetaWeblogStructs::Article]]

  api_method :deletePost,
    :expects => [
      {:appkey => :string},
      {:postid => :string},
      {:username => :string},
      {:password => :string},
      {:publish => :int}
    ],
    :returns => [:bool]

  api_method :editPost,
    :expects => [
      {:postid => :string},
      {:username => :string},
      {:password => :string},
      {:struct => MetaWeblogStructs::Article},
      {:publish => :int}
    ],
    :returns => [:bool]

  api_method :newPost,
    :expects => [
      {:blogid => :string},
      {:username => :string},
      {:password => :string},
      {:struct => MetaWeblogStructs::Article},
      {:publish => :int}
    ],
    :returns => [:string]

  api_method :newMediaObject,
    :expects => [
      {:blogid => :string},
      {:username => :string},
      {:password => :string},
      {:data => MetaWeblogStructs::MediaObject}
    ],
    :returns => [MetaWeblogStructs::Url]
end

class MetaWeblogService < DumboWebService
  web_service_api MetaWeblogApi
  before_invocation :authenticate_api

  # Get list of page categories.
  def getCategories(blogid, username, password)
    begin
      this_page.categories.names
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      []
    end
  end

  # Return a document.
  def getPost(postid, username, password)
    begin
      doc = this_page.documents.find_by_external_id(postid)
      raise(ActiveRecord::RecordNotFound) if doc.nil?

      document_dto_from(doc)
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      document_dto_from(Document.new) # XXX
    end
  end

  # Get list of recent documents.
  def getRecentPosts(blogid, username, password, numberOfPosts)
    begin
      this_page.documents.latest.limit(numberOfPosts).map do |doc|
        document_dto_from(doc)
      end
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      []
    end
  end

  # Create a new document.
  def newPost(blogid, username, password, struct, publish)
    begin
      categories = struct['categories']
      published_at = struct['dateCreated'].to_time.getlocal rescue Time.now
    
      doc = Document.new.tap do |doc|
        doc.content = struct['description'].to_s
        doc.title = struct['title'].to_s
        doc.author = this_account
        doc.published_at = published_at
        doc.published = publish
        doc.page = this_page
        doc.categories = this_page.categories.many_matching(categories) # FIXME
      end
    
      doc.save!
      doc.external_id.to_s
    rescue Exception => e
      logger.error(e.message)

      # Return failure.
      nil.to_s
    end
  end

  # Delete a document.
  def deletePost(appkey, postid, username, password, publish)
    begin
      doc = this_page.documents.find_by_external_id(postid)
      raise(ActiveRecord::RecordNotFound) if doc.nil?
      
      doc.destroy
      true
    rescue Exception => e
      logger.error(e.message)
      
      # Return a failure.
      false
    end
  end

  # Edit a document.
  def editPost(postid, username, password, struct, publish)
    begin
      cats = struct['categories']
      published_at = struct['dateCreated'].to_time.getlocal rescue Time.now
      path = struct['link'].to_s
      
      doc = this_page.documents.find_by_external_id(postid).tap do |doc|
        doc.content = struct['description'].to_s
        doc.title = struct['title'].to_s
        doc.author = this_account
        doc.published_at = published_at
        doc.published = publish
        doc.path = path if path.present?
        
        this_page.categories.many_matching(cats).tap do |categories|
          # Do not reset categories if not specified explicitly.
          doc.categories = categories if struct.has_key?('categories')
        end
      end
      
      doc.save!
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      false
    end
  end
  
  def newMediaObject(blogid, username, password, data)
    begin
      tmp = Tempfile.new(data['name'].split('.'))
      tmp.write(data['bits'])
      tmp.close
      
      resource = this_page.resources.create!(:name => data['name'])
      resource.resource = File.open(tmp.path)
      resource.save!
            
      MetaWeblogStructs::Url.new('url' => resource.url.to_s)
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      MetaWeblogStructs::Url.new('url' => this_page.url) # FIXME
    end
  end

  protected
    def document_dto_from(doc)
      MetaWeblogStructs::Article.new(
        :description => doc.content,
        :title => doc.title,
        :postid => doc.external_id,
        :url => doc.url,
        :link => doc.url,
        :permaLink => doc.url,
        :mt_allow_comments => 0,
        :mt_allow_pings => 0,
        :categories => doc.categories.names,
        :dateCreated => (doc.published_at ? doc.published_at.utc : nil.to_s)
      )
    end
end
