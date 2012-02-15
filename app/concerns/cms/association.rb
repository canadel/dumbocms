module Cms
  module Association
    
    module Array
      extend ActiveSupport::Concern
      
      module ClassMethods
        def to_liquid
          all.map(&:to_liquid)
        end
      end
    end
    
    module Hash
      
      module ClassMethods
        def to_liquid
          raise(ArgumentError, 'no slug') unless self.columns.include?(:slug)
          
          all.inject(ActiveSupport::OrderedHash.new) do |ret, v|
            ret[ret.slug] = v
            ret
          end
        end
      end
    end
    
  end
end