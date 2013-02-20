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
#
Cms::Application.routes.draw do
  # Prefix route urls with "admin" and route names with "rails_admin_"
  #--
  # Do I correctly understand that Rails 3.1 handles it slightly better than
  # the current shit?
  #++
  
  scope "admin", :module => :rails_admin, :as => "rails_admin" do
    # FIXME: Comment out.
    scope "history", :as => "history" do
      controller "history" do
        match "/list", :to => :list, :as => "list"
        match "/slider", :to => :slider, :as => "slider"
        match "/:model_name", :to => :for_model, :as => "model"
        match "/:model_name/:id", :to => :for_object, :as => "object"
      end
    end

    # Routes for rails_admin controller
    controller "main" do
      match "/", :to => :index, :as => "dashboard"
      get "/:model_name", :to => :list, :as => "list"
      post "/:model_name/list", :to => :list, :as => "list_post"
      match "/:model_name/export", :to => :export, :as => "export"
      get "/:model_name/new", :to => :new, :as => "new"
      match "/:model_name/get_pages", :to => :get_pages, :as => "get_pages"
      post "/:model_name", :to => :create, :as => "create"

      get "/:model_name/:id", :to => :show, :as => "show"
      get "/:model_name/:id/edit", :to => :edit, :as => "edit"
      put "/:model_name/:id", :to => :update, :as => "update"
      get "/:model_name/:id/delete", :to => :delete, :as => "delete"
      delete "/:model_name/:id", :to => :destroy, :as => "destroy"

      post "/:model_name/bulk_action", :to => :bulk_action, :as => "bulk_action"
      post "/:model_name/bulk_destroy", :to => :bulk_destroy, :as => "bulk_destroy"
    end
  end

  namespace :api do
    
    namespace :v1 do
      resources :domains
      resources :pages do
        resources :documents
        resources :categories
      end
      resources :templates
    end

    scope :module => :v1 do
      resources :domains
      resources :pages do
        resources :documents
        resources :categories
      end
      resources :templates
      match 'pages(/:id)', :controller => 'pages', :action => 'options', :constraints => { :method => 'OPTIONS' } 
    end

  end


  Mime::Type.register("text/plain", :txt) # XXX required?
  
  # Work around the Bad URI bug
  scope(:format => false) do
    %w{ backend }.each do |i|
      match "#{i}", :to => "#{i}#index"
      match "#{i}(/:action)", :to => i
      match "#{i}(/:action(/:id))", :to => i, :id => nil
    end
  end
  
  # Be a little hacky.
  scope(:to => 'backend#xmlrpc', :format => false) do
    match '/xmlrpc.php'
    match '/wordpress/xmlrpc.php'
    match '/wp/xmlrpc.php'
  end
  
  # http://en.wikipedia.org/wiki/Really_Simple_Discovery
  match '/rsd.xml', :to => 'rsd#index', :as => :rsd
  
  scope(:format => false) do
    match '/index.rss', :to => 'rss#index', :as => :rss
    match '/index.atom', :to => 'atom#index', :as => :atom
    match '/sitemap.xml', :to => 'sitemap#index', :as => :sitemap
    match '/robots.txt', :to => 'robots#index', :as => :robots
  end
  
  match '/', :to => 'dispatcher#do'
  match '/:path', :to => 'dispatcher#do', :constraints => { :path => /.*/ }
end
