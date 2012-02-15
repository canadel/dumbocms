module Cms
  module HasMany
    extend ActiveSupport::Concern
    
    module ClassMethods
      def define_has_many(arr, options={})
        arr.to_a.each {|obj| has_many obj.to_sym, options }
      end
    end
  end
end
