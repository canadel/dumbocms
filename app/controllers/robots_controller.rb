class RobotsController < ApplicationController
  
  skip_before_filter :authenticate
  before_filter :set
  
  def index #:nodoc:
    
    if @page && @page.robots_txt.present?
      render(text: @page.robots_txt, status: :ok)
    else
      render(text: 'Not Found', status: :not_found) # FIXME
    end
  end
end
