module Cms
  module Name
    extend ActiveSupport::Concern
    
    module ClassMethods
      
      def define_name(nejm=:name, options={})
        nejm = nejm.to_sym
        options = options.symbolize_keys.merge(presence: true)
        
        define_method(:nejm) { nejm }
        define_method(:to_s) { send(nejm) }
        
        alias_method :admin_object_label, :to_s
        
        scope :alphabetically, order("#{table_name}.#{nejm} ASC")
        scope :not_alphabetically, order("#{table_name}.#{nejm} DESC")

        validates nejm, options

        true
      end
      
      # Return names of all categories.
      def names
        alphabetically.map(&:to_s) # SQL
      end
    end
  end
end