class Api::V1::DocumentsController < Api::V1::ApiController
  defaults({
    :resource_class => Document,
    :collection_name => 'documents',
    :instance_name => 'document'
  })
  
  protected
    def set_page
      @page = Page.find(params[:page_id])
    end
    
    def begin_of_association_chain
      @page
    end
end
