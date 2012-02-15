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

xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.rsd "version" => "1.0", "xmlns" => "http://archipelago.phrasewise.com/rsd" do
  xml.service do
    xml.engineName Rails.configuration.dumbocms.app
    xml.engineLink Rails.configuration.dumbocms.homepage
    xml.homePageLink @page.url
    xml.apis do
      xml.api "name" => "Movable Type", "preferred"=>"true",
              "apiLink" => url_for(:controller => "backend", :action => "xmlrpc", :only_path => false),
              "blogID" => @page.id
      xml.api "name" => "MetaWeblog", "preferred"=>"false",
              "apiLink" => url_for(:controller => "backend", :action => "xmlrpc", :only_path => false),
              "blogID" => @page.id
      xml.api "name" => "Blogger", "preferred"=>"false",
              "apiLink" => url_for(:controller => "backend", :action => "xmlrpc", :only_path => false),
              "blogID" => @page.id
    end
  end
end
