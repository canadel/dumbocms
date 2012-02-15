module Cms
  module Slug
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      # define_slug :scope => :page
      # define_slug :scope => :page, :from => :title
      def define_slug(options={})
        options = options.symbolize_keys
        options.assert_valid_keys(:from, :scope)
        
        skope = "#{options[:scope]}_id".to_sym
        
        if options.has_key?(:from)
          from = options[:from].to_sym
          has_permalink from, :slug, :scope => skope, :unique => true
        end
        
        validates :slug,
          :presence => true,
          :uniqueness => { :scope => skope },
          :length => { :minimum => 3, :maximum => 255 },
          :format => Cms::Format::SLUG

        true
      end
    end
  end
end