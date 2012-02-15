class DispatcherController < ApplicationController

  skip_before_filter :authenticate
  before_filter :set
  
  def do
    logger.debug "Handling the incoming web request."

    do_redirect and do_render and do_headers
    logger.info "Handled the incoming web request."
    true
  end
  
  protected
    # {Redirect}[http://www.google.com/support/webmasters/bin/answer.py?answer=93633]?
    def do_redirect
      logger.debug "Redirecting the domain '#{@domain}'."

      if @domain.nil?
        # Do not found if unknown domain.
        render(action: 'not_found_domain', status: :not_found)
        logger.info "Domain '#{request.host}' is Not Found, a HTTP 404."
        return false # FIXME
      elsif @page && @page.redirect_to.present?
        # Do redirect if the domain is redirecting.
        # TODO: Redirect to the preferred first?
        redirect_to @page.url,
          text: "Moved Permanently",
          status: :moved_permanently
          
        logger.info "Redirecting to #{@page.url}."
        return false # FIXME
      elsif @domain.preferred?
        # http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=44231
        # Do render the document if a {preferred domain}[http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=44231].
        logger.info "Domain '#{@domain}' is a preferred domain."
        return true # FIXME
      elsif @document.nil?
        redirect_to @page.url,
          text: "Moved Permanently",
          status: :moved_permanently
          
        logger.info "Redirecting to #{@page.url}."
        return false # FIXME
      else
        # Do redirect if the path is not a canonical URL.
        # Do redirect if the domain is not a preferred domain.
        redirect_to @document.url,
          text: "Moved Permanently",
          status: :moved_permanently

        logger.info "Redirecting to #{@document.url}."
        return false # FIXME
      end
    end
    
    # Render the page, if the preferred domain.
    def do_render
      logger.debug("Rendering the path '#{@path}' of page '#{@page}'.")
      
      if @document.nil?
        # FIXME: ugly
        
        if !@page.documents.not_found? && @page.documents.any?
          if @page.development?
            # Render the informative error message, if development.
            render(action: 'not_found_document', status: :not_found)
          else
            # Render the generic not_found, if none specified.
            render(text: 'Not Found', status: :not_found)
          end
          
          logger.info "Document '#{@document}' is Not Found, a HTTP 404."
          return false # break
        elsif @page.documents.not_found? && @page.documents.any?
          # Render the not_found document if specified.
          @document = @page.documents.not_found
        elsif @page.documents.empty?
          @document = @page.documents.stub(page: @page) # FIXME ???
        end
      end

      text, content_type = @document.render_fresh(params)

      render(
        text: text,
        content_type: content_type,
        status: @document.status
      )
      
      logger.info "Rendered the document '#{@document}' of page '#{@page}'."
      true
    end
  
  private
    # HTTP/1.0 302 Found
    # Location: http://www.google.de/
    # Cache-Control: private
    # Content-Type: text/html; charset=UTF-8
    # Set-Cookie: PREF=ID=bee270f7652dcb93:FF=0:TM=1314562863:LM=1314562863:S=zzzX7ex6Aexj3r5a; expires=Tue, 27-Aug-2013 20:21:03 GMT; path=/; domain=.google.com
    # Date: Sun, 28 Aug 2011 20:21:03 GMT
    # Server: gws
    # Content-Length: 218
    # X-XSS-Protection: 1; mode=block
    def do_headers # :nodoc:
      logger.debug "Rendering the HTTP Headers."
      
      #--
      # XXX think of custom Servers for the sake of misleading Google
      #++
      # TODO switch to response.server = 'gws', once tested
      response.header['Server'] = @document.page.http_server
      
      # Indicate
      # {the canonical version}[http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=139066]
      # of a URL by responding with
      # {the Link rel="canonical" HTTP header}[http://googlewebmastercentral.blogspot.com/2011/06/supporting-relcanonical-http-headers.html].
      response.headers['Link'] = "<#{@document.url}>; rel=\"canonical\""
      
      # http://www.mnot.net/cache_docs/#CACHE-CONTROL
      # public — marks authenticated responses as cacheable; normally,
      # if HTTP authentication is required, responses are automatically
      # private.
      response.cache_control[:public] = true

      # http://www.mnot.net/cache_docs/#VALIDATE
      #
      # Note that Last-Modified at relies on the cache. See Document#render!
      # for implementation details.
      #--
      # FIXME: I expect some exceptions here, I'd say
      # FIXME: switch to .utc
      # FIXME: in sitemaps, too
      #++
      # Please note that response.last_modified calls #httpdate on its own.
      response.last_modified = @document.last_modified_at.utc

      # Get rid of this crap:
      #
      # X-Powered-By: Phusion Passenger (mod_rails/mod_rack) 3.0.9
      # X-UA-Compatible: IE=Edge,chrome=1
      #
      response.headers['X-Powered-By'] = nil.to_s
      response.headers['X-UA-Compatible'] = nil.to_s
      response.headers['X-Runtime'] = nil.to_s
      
      #
      # Do not index pages in Google.
      #
      # http://code.google.com/web/controlcrawlindex/docs/robots_meta_tag.html
      # http://code.google.com/webstats/2005-12/httpheaders.html
      #
      # X-Robots-Tag: noindex
      #
      response.headers['X-Robots-Tag'] = 'noindex' if @page.noindex?
      
      logger.info "Rendered the HTTP headers."
      true
    end
end
