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

require 'action_web_service'

class BackendController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate

  web_service_dispatching_mode :layered
  web_service_exception_reporting false

  web_service(:blogger) { BloggerService.new(self) }
  web_service(:metaWeblog) { MetaWeblogService.new(self) }
  web_service(:mt) { MovableTypeService.new(self) }
  web_service(:system) { SystemService.new(self) }
  # web_service(:wp) { WordpresService.new(self) }

  def xmlrpc; api; end
  def api; dispatch_web_service_request; end
  
  protected
    # Return the page.
    def this_page; set; @page; end
    
    # Change the page.
    def this_page=(q); @page = q; end
end
