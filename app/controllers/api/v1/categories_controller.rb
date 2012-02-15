class Api::V1::CategoriesController < Api::V1::ApiController
  before_filter :set_page
  
  defaults({
    :resource_class => Category,
    :collection_name => 'categories',
    :instance_name => 'category'
  })
  
  protected
    def set_page
      @page = Page.find(params[:page_id])
    end
    
    def begin_of_association_chain
      @page
    end
end
