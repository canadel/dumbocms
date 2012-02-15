class RobotsController < ApplicationController
  
  skip_before_filter :authenticate
  before_filter :set
  
  def index #:nodoc:
    
    if @page && @page.robots_txt.present?
      render(:text => @page.robots_txt, :status => 200) # TODO
    else
      render(:text => 'Not Found', :status => :not_found)
    end
  end
end
