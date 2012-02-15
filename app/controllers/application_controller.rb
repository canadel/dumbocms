#--
# TODO turn off cookies
# TODO proper caching on the application controller level
# it should create something like cachables that does nothing but providing
# for this
#++
class ApplicationController < ActionController::Base
  # XXX consider module, guard only /admin
  include SimplestAuth::Controller
  before_filter :authenticate
  
  protect_from_forgery
  
  protected
    # Set the domain, the page, and the path.
    def set
      # Haiku.  Love Thy Indent.
      set_domain and
        set_path and
        set_page and
        set_document
        
      true
    end

  private
    # Set the domain, a Domain, xor nil while unsuccessful.
    #
    # Use the params, if the request domain is unfamiliar.
    def set_domain
      logger.debug "Parsing the request domain '#{request.host}'."

      # FIXME
      path_hack = params[:path].split('/').reject(&:blank?)[0] if params[:path].present?
      
      # Haiku.
      @domain = Domain.matching_wildcard(path_hack)
      @domain_hack = ! @domain.nil?
      @domain ||= Domain.matching_wildcard(request.host)
      
      Rails.configuration.dumbocms.production = ! @domain_hack
      
      logger.info "Parsed the request domain '#{@domain}'."
      true
    end
    
    # Set the path, a String.
    def set_path
      logger.debug "Parsing the request path."

      path_hack = (params[:path].split('/').reject(&:blank?)[1..-1] || []).insert(0, '').join('/') if params[:path].present?
      
      if @domain_hack
        @path = path_hack.blank? ? '/' : path_hack
      else
        @path = request.path
      end
      
      logger.info "Parsed the request path '#{@path}'."
      true
    end
    
    # Set the page, a Page, xor nil while unsuccessful.
    def set_page
      logger.debug "Parsing the request page."

      @page = @domain.nil? ?
        nil :
        @domain.page
      @page = nil if !@page.nil? && !@page.published?
      
      logger.info "Parsed the request document '#{@document}'."
      true
    end
    
    # Set the document, a Document, xor nil while unsuccessful.
    def set_document
      logger.debug "Parsing the requested document."
      
      @document = @page.nil? ?
        nil :
        @page.documents_permalinks.matching(@path).try(:document) # FIXME
      @document = @page.frontpage if (!@page.nil? && @path == Permalink.frontpage_path)
      @document = ((@document.nil? || ! @document.published?) ? nil : @document) # FIXME
      
      logger.info "Parsed the requested document '#{@document}'."
      true
    end

    # Return the class responsible for authentication.
    def user_class; Account; end

    # Deny the access, then authenticate by HTTP Basic Auth.
    def access_denied; store_location; authenticate; end

    # Return the login message showed, while not authorized.
    def login_message; ["Bye."].join("<br>"); end

    # Authenticate the account.
    def authenticate
      #--
      # Please improve the authentication with:
      #
      # http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Basic.html
      #
      # TODO: Change the header.
      #++
      authenticate_or_request_with_http_basic("Dumbo CMS") do |email, password|
        # Ensure to reset the current user if the wrong password.
        self.current_user = Account.authenticate(email, password)

        # Render the login message, unless logged in.
        bye unless logged_in?

        # Return true if the current user is authenticated. 
        logged_in?
      end
    end

    # Deauthenticate the account.
    def deauthenticate
      # Reset the current user.
      self.current_user = nil

      # Reset the session.
      clear_session

      true
    end

    # Render the login message, and return the 403 HTTP Status.
    def bye(status=:forbidden)
      render({
        :text => login_message,
        :status => status
      })
    end
end
