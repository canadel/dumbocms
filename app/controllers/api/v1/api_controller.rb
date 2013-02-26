class Api::V1::ApiController < ApplicationController
  inherit_resources
  actions :index, :show, :create, :update, :destroy
 
  respond_to :json 

  #skip_before_filter :verify_authenticity_token  
  skip_before_filter :authenticate
  before_filter :authenticate_api_key, :except => [:options]
  after_filter :set_access_headers

  def options
    render :text => '', :content_type => 'text/plain'
  end

protected

  def authenticate_api_key
    token = request.headers['X-Auth-Key'] || params[:token]
    @account = Account.find_by_api_key(token) || Account.where('MD5(SUBSTR(SHA1(email), 5, 25)) = ?', token).first unless token.nil?
    bye if @account.nil?
  end
 
  def set_access_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Http-Method-Override'
    headers['Access-Control-Max-Age'] = '1728000'
  end

  #--
  # TODO: CanCan
  # def begin_of_association_chain; @account; end
  #++
end
