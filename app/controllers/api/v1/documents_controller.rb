class Api::V1::DocumentsController < Api::V1::ApiController
  defaults({
    :resource_class => Document,
    :collection_name => 'documents',
    :instance_name => 'document'
  })

  before_filter :set_page
 
  def index
    render :json => @page.documents.to_json, :callback => params[:callback]
  end

  def update
    document = Document.where(:id => params[:id]).first
    params[:document][:content_html] = BlueCloth::new(params[:document][:content]).to_html
    params[:document][:markup] = 'markdown'
    params[:document][:category_id] = params[:document][:category]
    params[:document].delete(:category)
    document.update_attributes(params[:document]) if @page.account_id == @account.id
    render :json => document, :callback => params[:callback]
  end

  def show

    doc = Document.find(params[:id])
    cats = Category.where(:page_id => doc.page_id)

    render :json => { :document => doc, :cats => cats }, :callback => params[:callback]
  end

  def create
    doc_params = params[:document]
    doc_params[:page_id] = @page.id
    Rails.logger.warn doc_params
    document = Document.create(doc_params) if @page.account_id == @account.id
    render :json => document, :callback => params[:callback]
  end

  protected
    def set_page
      @page = Page.find(params[:page_id])
    end
    
    def begin_of_association_chain
      @page
    end
end
