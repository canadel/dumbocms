class Api::V1::DomainsController < Api::V1::ApiController
  defaults({
    :resource_class => Domain,
    :collection_name => 'domains',
    :instance_name => 'domain'
  })

  def create
    domain = Domain.create(params[:domain])

    render :json => domain
  end

end
