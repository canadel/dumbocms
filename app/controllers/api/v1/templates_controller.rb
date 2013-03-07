class Api::V1::TemplatesController < Api::V1::ApiController
  defaults({
    :resource_class => Template,
    :collection_name => 'templates',
    :instance_name => 'template'
  })


  def index
    domain = Domain.where(:name => params[:domain]).first if params[:domain]
    Template.current = domain.page.template if domain
    render :json => Template.where(:published => true).to_json(:methods => :current), :callback => params[:callback]
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
