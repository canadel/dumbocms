require 'indextank'

indextank_url = ENV['INDEXTANK_API_URL'] ||
  'http://:kVQMwt9UJSadW7@uhsk.api.indextank.com'
client = IndexTank::Client.new(indextank_url)

$indextank = client.indexes('documents')