require 'facets/hash'

module Cms #:nodoc:
  module LiquidAttributes
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      def define_liquid_attributes(kolumns, renames={})
        default_renames = { external_id: :id }

        unless kolumns.is_a?(Array)
          raise(ArgumentError, 'kolumns is not array')
        end
        unless renames.is_a?(Hash)
          raise(ArgumentError, 'renames is not hash')
        end
        
        define_cattr(:liquid_attributes, kolumns.map(&:to_s))
        define_cattr(:liquid_attribute_renames,
          default_renames.merge(renames).stringify_keys)
      end
    end
    
    module InstanceMethods
      def to_liquid
        return({}) if self.liquid_attributes.nil?
        return({}) if self.liquid_attributes.empty?
        
        # Keys are strings.
        liquid_attributes.map(&:to_s).inject({}) do |ret, la|
          ret[liquid_method(la)] = liquid_value(send(la))
          ret
        end
      end
      
      protected
        # Return the real method that should be called for this attribute.
        def liquid_method(key)
          return key unless self.liquid_attribute_renames.has_key?(key)

          self.liquid_attribute_renames[key].to_s
        end
      
        def liquid_value(value)
          case value.class.name
          when 'NilClass'
            # Never return nil.
            value.to_s
          when 'Date', 'Time'
            # Leave dates and times untouched.
            value
          when 'Float', 'Integer'
            # Leave floats and integers untouched.
            value
          # when 'Array'
          #   #--
          #   # test_to_liquid_parent(CategoryTest):
          #   # SystemStackError: stack level too deep
          #   #     app/concerns/cms/liquid_attributes.rb:38:in `liquid_value'
          #   #     app/concerns/cms/liquid_attributes.rb:18:in `to_liquid'
          #   #     app/concerns/cms/liquid_attributes.rb:17:in `each'
          #   #     app/concerns/cms/liquid_attributes.rb:17:in `inject'
          #   #     app/concerns/cms/liquid_attributes.rb:17:in `to_liquid'
          #   #     app/concerns/cms/liquid_attributes.rb:55:in `liquid_value'
          #   #     app/concerns/cms/liquid_attributes.rb:52:in `liquid_value'
          #   #     app/concerns/cms/liquid_attributes.rb:52:in `liquid_value'
          #   #     app/concerns/cms/liquid_attributes.rb:18:in `to_liquid'
          #   #++
          #   value.map {|v| liquid_value(v) }
          else
            # Scope to String by default.
            value.respond_to?(:to_liquid) ? value.to_liquid : value.to_s
          end
        end
    end
  end
end