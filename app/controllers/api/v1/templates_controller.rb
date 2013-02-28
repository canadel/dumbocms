class Api::V1::TemplatesController < Api::V1::ApiController
  defaults({
    :resource_class => Template,
    :collection_name => 'templates',
    :instance_name => 'template'
  })


  def index
    render :json => Template.where(:published => true), :callback => params[:callback]
  end

  def choose
    template = Template.where(:name => params[:template]).first
    domain = Domain.where(:name => params[:domain]).first

    if template && domain
      page = domain.page
      page.template = template
      page.save
    end
    
    render :json => template, :callback => params[:callback]
  end

end
