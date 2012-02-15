class Api::V1::PagesController < Api::V1::ApiController
  defaults({
    :resource_class => Page,
    :collection_name => 'pages',
    :instance_name => 'page'
  })
end