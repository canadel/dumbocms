module FbFilters #:nodoc:
  include CmsFilters
  
  # http://developers.facebook.com/docs/reference/plugins/comments/
  #--
  # TODO: Support colorscheme.
  #++
  def fb_comments(href, width=nil, num_posts=nil, colorscheme=nil)
    num_posts ||= 2
    width ||= 300
    
    ret = <<-EOF
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) {return;}
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>

<div class="fb-comments" data-href="#{href}" data-num-posts="#{num_posts}" data-width="#{width}"></div>
EOF
    ret.html_safe
  end
end