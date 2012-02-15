require 'rails_admin/config/model'
require 'rails_admin/config/sections/list'
require 'rails_admin/config/sections/navigation'
require 'active_support/core_ext/class/attribute_accessors'

module RailsAdmin
  module Config
    class AuthenticationNotConfigured < StandardError; end
    # RailsAdmin is setup to try and authenticate with warden
    # If warden is found, then it will try to authenticate
    #
    # This is valid for custom warden setups, and also devise
    # If you're using the admin setup for devise, you should set RailsAdmin to use the admin
    #
    # By default, this will raise in any of the following environments
    #   * production
    #   * beta
    #   * uat
    #   * staging
    #
    # @see RailsAdmin::Config.authenticate_with
    # @see RailsAdmin::Config.authorize_with
    DEFAULT_AUTHENTICATION = Proc.new do
      warden = request.env['warden']
      if warden
        warden.authenticate!
      else
        if %w(production beta uat staging).include?(Rails.env)
          raise AuthenticationNotConfigured, "See RailsAdmin::Config.authenticate_with or setup Devise / Warden"
        end
      end
    end

    DEFAULT_AUTHORIZE = Proc.new {}

    DEFAULT_CURRENT_USER = Proc.new do
      warden = request.env["warden"]
      if warden
        warden.user
      elsif respond_to?(:current_user)
        current_user
      else
        raise "See RailsAdmin::Config.current_user_method or setup Devise / Warden"
      end
    end

    class << self
      # Configuration option to specify which models you want to exclude.
      attr_accessor :excluded_models

      # Configuration option to specify a whitelist of models you want to RailsAdmin to work with.
      # The excluded_models list applies against the whitelist as well and further reduces the models
      # RailsAdmin will use.
      # If included_models is left empty ([]), then RailsAdmin will automatically use all the models
      # in your application (less any excluded_models you may have specified).
      attr_accessor :included_models

      # Fields to be hidden in show, create and update views
      attr_accessor :default_hidden_fields

      # Fields to be hidden in export views
      attr_accessor :default_hidden_fields_for_export

      # Default items per page value used if a model level option has not
      # been configured
      attr_accessor :default_items_per_page

      attr_reader :default_search_operator

      # Configuration option to specify which method names will be searched for
      # to be used as a label for object records. This defaults to [:name, :title]
      attr_accessor :label_methods
      
      # hide blank fields in show view if true
      attr_accessor :compact_show_view
      
      # Stores model configuration objects in a hash identified by model's class
      # name.
      #
      # @see RailsAdmin::Config.model
      attr_reader :registry

      # Setup authentication to be run as a before filter
      # This is run inside the controller instance so you can setup any authentication you need to
      #
      # By default, the authentication will run via warden if available
      # and will run the default.
      #
      # If you use devise, this will authenticate the same as _authenticate_user!_
      #
      # @example Devise admin
      #   RailsAdmin.config do |config|
      #     config.authenticate_with do
      #       authenticate_admin!
      #     end
      #   end
      #
      # @example Custom Warden
      #   RailsAdmin.config do |config|
      #     config.authenticate_with do
      #       warden.authenticate! :scope => :paranoid
      #     end
      #   end
      #
      # @see RailsAdmin::Config::DEFAULT_AUTHENTICATION
      def authenticate_with(&blk)
        @authenticate = blk if blk
        @authenticate || DEFAULT_AUTHENTICATION
      end

      # Setup authorization to be run as a before filter
      # This is run inside the controller instance so you can setup any authorization you need to.
      #
      # By default, there is no authorization.
      #
      # @example Custom
      #   RailsAdmin.config do |config|
      #     config.authorize_with do
      #       redirect_to root_path unless warden.user.is_admin?
      #     end
      #   end
      #
      # To use an authorization adapter, pass the name of the adapter. For example,
      # to use with CanCan[https://github.com/ryanb/cancan], pass it like this.
      #
      # @example CanCan
      #   RailsAdmin.config do |config|
      #     config.authorize_with :cancan
      #   end
      #
      # See the wiki[https://github.com/sferik/rails_admin/wiki] for more on authorization.
      #
      # @see RailsAdmin::Config::DEFAULT_AUTHORIZE
      def authorize_with(*args, &block)
        extension = args.shift
        if(extension)
          @authorize = Proc.new {
            @authorization_adapter = RailsAdmin::AUTHORIZATION_ADAPTERS[extension].new(*([self] + args).compact)
          }
        else
          @authorize = block if block
        end
        @authorize || DEFAULT_AUTHORIZE
      end

      # Setup configuration using an extension-provided ConfigurationAdapter
      #
      # @example Custom configuration for role-based setup.
      #   RailsAdmin.config do |config|
      #     config.configure_with(:custom) do |config|
      #       config.models = ['User', 'Comment']
      #       config.roles  = {
      #         'Admin' => :all,
      #         'User'  => ['User']
      #       }
      #     end
      #   end
      def configure_with(extension)
        configuration = RailsAdmin::CONFIGURATION_ADAPTERS[extension].new
        yield(configuration) if block_given?
      end

      # Setup a different method to determine the current user or admin logged in.
      # This is run inside the controller instance and made available as a helper.
      #
      # By default, _request.env["warden"].user_ or _current_user_ will be used.
      #
      # @example Custom
      #   RailsAdmin.config do |config|
      #     config.current_user_method do
      #       current_admin
      #     end
      #   end
      #
      # @see RailsAdmin::Config::DEFAULT_CURRENT_USER
      def current_user_method(&block)
        @current_user = block if block
        @current_user || DEFAULT_CURRENT_USER
      end

      def default_search_operator=(operator)
        if %w{ default like starts_with ends_with is = }.include? operator
          @default_search_operator = operator
        else
          raise ArgumentError, "Search operator '#{operator}' not supported"
        end
      end

      # Shortcut to access the list section's class configuration
      # within a config DSL block
      #
      # @see RailsAdmin::Config::Sections::List
      def list
        ActiveSupport::Deprecation.warn("RailsAdmin::Config.list is deprecated", caller)
        RailsAdmin::Config::Sections::List
      end

      # Loads a model configuration instance from the registry or registers
      # a new one if one is yet to be added.
      #
      # First argument can be an instance of requested model, its class object,
      # its class name as a string or symbol or a RailsAdmin::AbstractModel
      # instance.
      #
      # If a block is given it is evaluated in the context of configuration instance.
      #
      # Returns given model's configuration
      #
      # @see RailsAdmin::Config.registry
      def model(entity, &block)
        key = begin
          if entity.kind_of?(RailsAdmin::AbstractModel)
            entity.model.name.to_sym
          elsif entity.kind_of?(Class)
            entity.name.to_sym
          elsif entity.kind_of?(String) || entity.kind_of?(Symbol)
            entity.to_sym
          else
            entity.class.name.to_sym
          end
        end
        config = @registry[key] ||= RailsAdmin::Config::Model.new(entity)
        config.instance_eval(&block) if block
        config
      end

      # Returns all model configurations
      #
      # If a block is given it is evaluated in the context of configuration
      # instances.
      #
      # @see RailsAdmin::Config.registry
      def models(&block)
        RailsAdmin::AbstractModel.all.map{|m| model(m, &block)}
      end

      # Shortcut to access the navigation section's class configuration
      # within a config DSL block
      #
      # @see RailsAdmin::Config::Sections::Navigation
      def navigation
        ActiveSupport::Deprecation.warn("RailsAdmin::Config.navigation is deprecated", caller)
        RailsAdmin::Config::Sections::Navigation
      end

      # Reset all configurations to defaults.
      #
      # @see RailsAdmin::Config.registry
      def reset
        @compact_show_view = true
        @authenticate = nil
        @authorize = nil
        @current_user = nil
        @default_hidden_fields = [:id, :created_at, :created_on, :deleted_at, :updated_at, :updated_on, :deleted_on]
        @default_hidden_fields_for_export = []
        @default_items_per_page = 20
        @default_search_operator = 'default'
        @excluded_models = []
        @included_models = []
        @label_methods = [:name, :title]
        @registry = {}
      end

      # Reset a provided model's configuration.
      #
      # @see RailsAdmin::Config.registry
      def reset_model(model)
        key = model.kind_of?(Class) ? model.name.to_sym : model.to_sym
        @registry.delete(key)
      end

      # Get all models that are configured as visible sorted by their weight and label.
      #
      # @see RailsAdmin::Config::Hideable
      def visible_models
        self.models.select {|m| m.visible? }.sort do |a, b|
          (weight_order = a.weight <=> b.weight) == 0 ? a.label.downcase <=> b.label.downcase : weight_order
        end
      end
    end

    # Set default values for configuration options on load
    self.reset
  end
end