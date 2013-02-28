RailsAdmin.config do |config|
  # The authentication is handled by HTTP Basic Auth.
  config.authenticate_with { authorized? || access_denied }

  # The authorization is handld by CanCan.
  config.authorize_with :cancan

  # Return the current user.
  config.current_user_method { current_user }

  # Set the managed models.
  config.included_models = [
    Account,
    Document,
    Domain,
    Page,
    BulkImport,
    Category,
    Plan,
    Company,
    Template
  ]

  config.model(Company) do
    object_label_method { :admin_object_label }
    
    list do
      field(:name) { show }
    end
    
    [:show, :edit, :create, :update].each do |view|
      send(view) do
        field(:name) { show }
        field(:plan) { show }
        field(:timezone) { show }
      end
    end
  end
  
  config.model(Company) do
    object_label_method { :admin_object_label }
    
    list do
      field(:id) { show }
      field(:name) { show }
    end
    
    [:show, :edit, :create, :update].each do |view|
      send(view) do
        field(:name) { show }
        field(:plan) { show }
      end
    end
  end
  
  config.model(Plan) do
    object_label_method { :admin_object_label }
    
    list do
      field(:id) { show}
      field(:name) { show }
    end
    
    [:show, :edit, :create, :update].each do |view|
      send(view) do
        field(:name) { show }
        field(:companies) { show }
        
        group :subscription do
          label 'Subscription'
          
          field(:trial_length) { show }
          field(:trial_credit_card) { show }
          field(:billing_day_of_month) { show }
          field(:billing_price) { show }
        end
        
        group :limits do
          label 'Hard limits'
          
          field(:domains_limit) { show }
          field(:pages_limit) { show }
          field(:templates_limit) { show }
          field(:users_limit) { show }
          field(:documents_limit) { show }
          
          field(:storage_limit) do
            label 'Storage limit, in bytes (by default 1G)'
            show
          end
        end
      end
    end
  end

  config.model(Account) do
    object_label_method { :admin_object_label }
    
    list do
      field(:email) { show }
      field(:name) { show }
    end
    
    show do
      field(:email) { show }
      field(:name) { show }
    end
    
    [:edit, :create, :update].each do |view|
      send(view) do
        field(:email) { show }
        field(:name) { show }
        field(:super_user) { show }

        group :change_password do
          label "Change password"
          
          field(:password) { show }
          field(:password_confirmation) { show }
        end
        
        group :company do
          label 'Company settings'
          
          field(:company) { show }
          field(:role) { show }
        end
      end
    end
  end
  
  config.model(Category) do
    object_label_method { :admin_object_label }
    
    list do
      field(:id) { show }
      field(:page) { show }
      field(:slug) { show }
      field(:name) { show }
    end
    
    [:show, :edit, :create, :update].each do |view|
      send(view) do
        field(:page) { show }
        field(:name) { show }
        field(:slug) { show }
        field(:position) { show }
        
        group(:advanced) do
          label 'Advanced'
          
          field(:permalinks) { show }
          field(:parent) do
            label 'Parent category'
            help 'Optional. Makes this category a child of the parent.'
            show
          end
        end
      end
    end
  end
  
  config.model(Document) do
    object_label_method { :admin_object_label }
    
    list do
      field(:page) { show }
      field(:slug) { show }
      field(:template) { show } # FIXME limit to the current page
      field(:published_at) { show }
    end
    
    [:show, :edit, :create, :update].each do |view|
      send(view) do
        field(:page) { show }
        field(:slug) { show }
        field(:kind) { show }
        field(:content) do
          show
          ckeditor(true)
        end
        field(:markup) { show }
        field(:published_at) { show }
        
        group(:categories) do
          label 'Categories'
          
          field(:category) do
            label 'Primary category'
            help 'Optional. Uses the first category, if none set.'
            show
          end
          
          field(:categories) { show }
        end
        
        group :advanced do
          label "Advanced"

          field(:path) { show }
          field(:template) do
            label "Document template"
            help 'Optional. Use the page template, if none set.'
            show
          end
          
          field(:title) { show }
          field(:language) { show }
          field(:description) { show }
        end
        
        group(:geocoding) do
          label "Geocoding"
          
          field(:latitude) { show }
          field(:longitude) { show }
        end
      end
    end
  end
  
  config.model(Domain) do
    object_label_method { :admin_object_label }

    [:list, :show].each do |view|
      send(view) do
        field(:name) { show }
        field(:page) { show }
        field(:wildcard) { show }
      end
    end
  end
  
  config.model(Page) do
    object_label_method { :admin_object_label }
    
    list do
      field(:id) { show }
      field(:name) { show }
      field(:account) { show }
      field(:indexable) do
        label 'Index?'
        show
      end
    end
    
    [:show, :edit, :create, :update].each do |view|
      send(view) do
        field(:account) { show }
        
        field(:template) do
          label "Application template"
          help 'Require. Default for template for documents.'
          show
        end

        field(:name) { show }
        field(:permalinks) { show }
        field(:categories) { show }
        field(:documents) { show }
        
        group :custom do
          label "Custom"
          
          field(:redirect_to) do
            label "Redirect to"
            help 'Optional. Works as normal, if none set.'
          end
          
          field(:domain) do
            label "Preferred domain"
            help 'Optional. Use the first domain, if none set.'
            show
          end
          field(:domains) { show }
      
          field(:default_language) { show }
          field(:title) { show }
          field(:description) { show }
          field(:published_at) { show }
          field(:snippets) { show }
        end
        
        group(:google) do
          label 'Custom Google tags'

          # field(:google_site_verification) { show }
          field(:google_analytics_tracking_code) { show }
        end
        
        group(:seo) do
          label "Search Engine Optimization"
          
          field(:indexable) do
            label "Index?"
            help "Should the page be indexed in Google, and other engines?"
            show
          end
          
          field(:robots_txt) do
            label "robots.txt"
            help "Returned as /robots.txt"
            show
          end
        end
        
        group(:feeds) do
          label 'Feeds'
          
          field(:sitemap) do
            label "Sitemap?" 
            help 'Generate the sitemap, under /sitemap.xml?'
            show
          end
          
          field(:atom) do
            label "Atom?"
            help "Generate the Atom feed, under /index.atom?"
            show
          end
          
          field(:rss) do
            label "RSS?"
            help "Generate the RSS feed, under /index.rss?"
            show
          end
        end
        
        group(:geocoding) do
          label "Geocoding"

          field(:georss) do
            label "GeoRSS?"
            show
          end



          field(:latitude) { show }
          field(:longitude) { show }
        end
        
        group(:open_graph) do
          label 'Open Graph'
          
          field(:ogp) do
            label 'Open Graph?'
            help 'Enable Open Graph?'
            show
          end
        end
        
        group(:very_advanced) do
          label 'Touch only if you know what you actually do.'
          
          field(:http_server) do
            label 'HTTP Server. It aims to trick Google.'
            show
          end
        end
      end
    end
  end
  
  config.model(BulkImport) do
    list do
      field(:account) { show }
      field(:record) { show }
      field(:state_html) do
        label 'Status'
        pretty_value { value }
        show
      end
    end
    
    show do
      field(:record) { show }
      field(:state_html) do
        label 'Status'
        pretty_value { value }
        show
      end
      field(:output_html) do
        label 'Output'
        pretty_value { value }
        show
      end
    end
    
    create do
      field(:account) { show }
      field(:record) { show }
      field(:csv) { show }
    end
  end

  config.model(Template) do
    object_label_method { :admin_object_label }
    
    list do
      field(:id) { show }
      field(:name) { show }
      field(:thumbnail) { show }
      field(:published) { show }
    end
    
    [:show, :edit, :create, :update].each do |view|
      send(view) do
        field(:id) { show }
        field(:name) { show }
        field(:thumbnail) { show }
        field(:published) { show }
      end
    end
  end
end
