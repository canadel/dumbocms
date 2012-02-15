require 'facets/string'
require 'facets/hash'
require 'liquid'

module Cms
  class Fitler
    class RecordInvalid < StandardError
      attr_reader :record
    
      def initialize(record)
        @record = record
      
        super(@record.errors.full_messages.join(", ")) # FIXME: i18n
      end
    end
    
    # Mutable since not freezed.
    FITLER_PATH = File.join(Rails.root, 'app/views/liquid')

    attr_accessor :name
    attr_accessor :params

    def initialize(name)
      self.name = name.to_s
      self.params = {}
      self.class_eval do
        #--
        # TODO move back to the class
        #
        # <"Liquid error: undefined method `_validate_callbacks' for #<Class:Cms::Fitler>">.
        # <"Liquid error: undefined method `input' for #<Cms::Fitler:0x10afa3b00>">.
        #++
        include ActiveModel::Validations
        
        validates :input, :presence => true
        
        def []=(k, v)
          self.params[k.to_s] = v
        end

        def read_attribute_for_validation(k)
          self.params[k.to_s]
        end
      end

      @@template = Liquid::Template.parse(File.read(template_path))
    
      true
    end
  
    def render
      return nil unless self.valid?

      #--
      # TODO raise an exception notification
      #
      # It's not designer's fail that we've failed.  It should return nil,
      # and send an exception notification.
      #++
      raise(ArgumentError, 'no name') if self.name.blank?
    
      ret = @@template.render('fitler' => self.params.stringify_keys)
      ret.strip.html_safe
    end
  
    def render!
      self.render || raise(RecordInvalid.new(self))
    end
  
    protected
      def template_path
        #--
        # TODO raise an exception notification
        #
        # It's not designer's fail that we've failed.  It should return nil,
        # and send an exception notification.
        #++
        File.join(FITLER_PATH, [self.name, '.liquid'].join)
      end
  end
end