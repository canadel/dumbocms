module Cms #:nodoc:
  module Geo #:nodoc:
    extend ActiveSupport::Concern
    
    included do #:nodoc:
      # alias_attribute :geo, :coordinates
      # alias_attribute :geo?, :coordinates
    end

    module InstanceMethods #:nodoc:
      # Return true if both coordinates are specified.
      #--
      # How is better?
      #
      #   coordinates.any?(&:blank)
      #++
      def coordinates?
        [ self.latitude, self.longitude ].none?(&:nil?)
        # pick(:latitude, :longitude).any?(&:blank?)
      end
      
      def geo
        coordinates
      end
      
      def geo?
        coordinates?
      end
      
      # Return the coordinates, xor nil if none.
      def coordinates
        coordinates? ? [ self.latitude, self.longitude ] : nil
        # coordinates? ? pick(:latitude, :longitude) : nil
      end
    end
  end
end