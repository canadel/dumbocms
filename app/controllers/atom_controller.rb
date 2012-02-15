class AtomController < ApplicationController

  skip_before_filter :authenticate
  before_filter :set

  def index #:nodoc:
    raise(ActionController::RoutingError) if @page.nil?
    raise(ActionController::RoutingError) unless @page.atom?
    
    @documents = @page.documents

    respond_to do |format|
      format.atom { render layout: false }
    end
  end
end
