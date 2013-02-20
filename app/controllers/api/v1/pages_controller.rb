class Api::V1::PagesController < Api::V1::ApiController

  defaults({
    :resource_class => Page,
    :collection_name => 'pages',
    :instance_name => 'page'
  })

  def index
    render :json => @account.pages, :callback => params[:callback]
  end

  def show
    render :json => Page.where(:id => params[:id], :account_id => @account.id), :callback => params[:callback]
  end

  def create
    #page = Page.new
    #page.title = params[:title] if params[:title]
    #page.description = params[:descriptipn] if params[:description]
    #page.save
    render :text => 'hello, baby'
  end

  def update
    page = Page.where(:id => params[:id], :account_id => @account.id).first
  
    if page
      page.title = params[:page][:title] if params[:page][:title]
      page.description = params[:page][:description] if params[:page][:description]

      if page.save
        render :text => 'Success', :status => '200'
      else
        render :text => 'Fail', :status => 500
      end

    else
      render :text => 'Error', :status => 404
    end
  end

end
