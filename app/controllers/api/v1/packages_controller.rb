class Api::V1::PackagesController < Api::V1::ApiController
  defaults({
    :resource_class => Template,
    :collection_name => 'templates',
    :instance_name => 'template'
  })

  def index
    render :json => Package.where(:published => true).order('position ASC').to_json, :callback => params[:callback]
  end

end
