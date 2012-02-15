class Api::V1::ApiController < ApplicationController
  inherit_resources

  actions :index, :create, :destroy, :show, :update
  respond_to :json
  
  skip_before_filter :authenticate
  before_filter :authenticate_api_key
  
  protected
    def authenticate_api_key
      @account = Account.find_by_api_key(request.headers['X-Auth-Key'])
      bye if @account.nil?
    end

    #--
    # TODO: CanCan
    # def begin_of_association_chain; @account; end
    #++
end
