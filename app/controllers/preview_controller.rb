class PreviewController < ApplicationController

  skip_before_filter :authenticate

  def show

      @page = Page.where(:id => params[:page]).first if params[:page]
      @document = Document.where(:id => params[:document]).first if params[:document]
      @document = @page.documents.stub(page: @page) if @document.nil?

      if @document
        text, content_type = @document.render_fresh(params)
        render text: text, content_type: content_type, status: @document.status
      else
        render :text => 'Not found', :status => 404
      end
  
  end

end
