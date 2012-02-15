Cms::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.cache_store = :dalli_store
  config.serve_static_assets = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  # config.logger = Logglier.new("http://logs.loggly.com/inputs/fdd5f313-69f8-439f-bdcd-9da76c4c3faa")
end
