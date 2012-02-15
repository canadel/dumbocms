# http://en.wikipedia.org/wiki/Really_Simple_Discovery
# http://cyber.law.harvard.edu/blogs/gems/tech/rsd.html
class RsdController < ApplicationController
  
  skip_before_filter :authenticate
  before_filter :set

  def index #:nodoc:
    
    if @page
      render :layout => false
    else
      render(:text => 'Not Found', :status => :not_found)
    end
  end
end
