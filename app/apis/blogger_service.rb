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

module BloggerStructs
  class Blog < ActionWebService::Struct
    member :url,      :string
    member :blogid,   :string
    member :blogName, :string
  end
  class User < ActionWebService::Struct
    member :userid, :string
    member :firstname, :string
    member :lastname, :string
    member :nickname, :string
    member :email, :string
    member :url, :string
  end
end


class BloggerApi < ActionWebService::API::Base
  inflect_names false

  api_method :deletePost,
    :expects => [
      {:appkey => :string},
      {:postid => :int},
      {:username => :string},
      {:password => :string},
      {:publish => :bool}
    ],
    :returns => [:bool]

  api_method :getUserInfo,
    :expects => [
      {:appkey => :string},
      {:username => :string},
      {:password => :string}
    ],
    :returns => [BloggerStructs::User]

  api_method :getUsersBlogs,
    :expects => [
      {:appkey => :string},
      {:username => :string},
      {:password => :string}
    ],
    :returns => [ [BloggerStructs::Blog] ]

  api_method :newPost,
    :expects => [
      {:appkey => :string},
      {:blogid => :string},
      {:username => :string},
      {:password => :string},
      {:content => :string},
      {:publish => :bool}
    ],
    :returns => [:int]
end


class BloggerService < DumboWebService
  web_service_api BloggerApi
  before_invocation :authenticate_api
  
  # Delete a post.
  def deletePost(appkey, postid, username, password, publish)
    begin
      this_page.documents.find_by_external_id(postid.to_i).destroy
      true
    rescue Exception => e
      logger.error(e.message)

      # Return failure.
      false
    end
  end

  # Return user's info.
  def getUserInfo(appkey, username, password)
    begin
      BloggerStructs::User.new({
        :userid => @account.id,
        :firstname => "",
        :lastname => @account.name,
        :nickname => @account.to_s,
        :email => @account.email,
        :url => this_page.url
      })
    rescue Exception => e
      # Return failure.
      logger.error(e.message)
      
      BloggerStructs::User.new({}) # XXX
    end
  end

  # Return list of user's pages.
  def getUsersBlogs(appkey, username, password)
    begin
      this_page.account.pages.map do |page|
        BloggerStructs::Blog.new({
          :url => page.url,
          :blogid => page.external_id,
          :blogName => page.to_s
        })
      end
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      []
    end
  end
  
  # Create a new post. Return post's ID.
  def newPost(appkey, blogid, username, password, content, publish)
    begin
      re = %r{^<title>(.+?)</title>(?:<category>(.+?)</category>)?(.+)$}mi
      title, categories, body = content.match(re).captures rescue nil

      body ||= content.to_s
      title ||= body.to_s.split.split(0..5).join(' ')
      categories = categories.to_s.split(',')

      doc = Document.new.tap do |doc|
        doc.content = body
        doc.title = title
        doc.published = publish
        doc.author = @account
        doc.page = this_page
        doc.categories = this_page.categories.many_matching(categories)
      end
      
      doc.save!
      doc.external_id
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      0
    end
  end
end
