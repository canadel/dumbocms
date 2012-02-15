#
# Sitemaps are an easy way for webmasters to inform search engines about
# pages on their sites that are available for crawling. In its simplest
# form, a Sitemap is an XML file that lists URLs for a site along with
# additional metadata about each URL (when it was last updated, how often it
# usually changes, and how important it is, relative to other URLs in the
# site) so that search engines can more intelligently crawl the site.
#
# http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=156184&from=40318&rd=1
# http://www.sitemaps.org/
#
class SitemapController < ApplicationController
  
  skip_before_filter :authenticate
  before_filter :set
  
  def index #:nodoc:
    if @page.nil? || !@page.sitemap?
      render(text: 'Not Found', status: :not_found)
    else
      render(layout: false)
    end
  end
end
