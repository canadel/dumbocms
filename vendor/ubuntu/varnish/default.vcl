# This is a basic VCL configuration file for varnish.  See the vcl(7)
# man page for details on VCL syntax and semantics.
# 
# Default backend definition.  Set this to point to your content
# server.
#
backend default {
    .host = "127.0.0.1";
    .port = "8080";
}

# Drop any cookies sent to Dumbo.
sub vcl_recv {
  if (!(req.url ~ "(admin|development)")) {
    unset req.http.cookie;
  }
}

# Drop any cookies Dumbo tries to send back to the client.
sub vcl_fetch {
    if (!(req.url ~ "(admin|development)")) {
      unset beresp.http.set-cookie;
  }
}