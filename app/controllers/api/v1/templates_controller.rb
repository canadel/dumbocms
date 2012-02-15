class Api::V1::TemplatesController < Api::V1::ApiController
  defaults({
    :resource_class => Template,
    :collection_name => 'templates',
    :instance_name => 'template'
  })
end
