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

class SystemApi < ActionWebService::API::Base
  inflect_names false

  api_method :listMethods,
    :expects => [],
    :returns => [[:string]]
end


class SystemService < DumboWebService
  web_service_api SystemApi

  # See http://codex.wordpress.org/XML-RPC/system.listMethods for reference.
  def listMethods()
    begin
      ret = []
      ret << MovableTypeApi.api_methods.keys.map(&:to_s).sort
      # ret << MetaWeblogService.api_methods.keys.map(&:to_s).sort
      ret.flatten
    rescue Exception => e
      logger.error(e.message)
      
      # Return failure.
      []
    end
  end
end
