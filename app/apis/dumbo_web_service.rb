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

class DumboWebService < ActionWebService::Base
  attr_accessor :controller

  def initialize(controller); @controller = controller; end
  def this_page; controller.send(:this_page); end

  protected
    def authenticate_api(name, args)
      method = self.class.web_service_api.api_methods[name]
      h = method.expects_to_hash(args)
      
      # FIXME: Think of relying on ApplicationController more.
      @account = Account.authenticate(h[:username], h[:password])
      raise "Invalid login" unless @account
    end
    
    # Return this account.
    def this_account; @account; end

    # Return a logger, as a short cut.
    def logger; Rails.logger; end
end
