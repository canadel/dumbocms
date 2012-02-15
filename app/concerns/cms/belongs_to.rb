module Cms
  module BelongsTo
    extend ActiveSupport::Concern
    
    module ClassMethods
      def define_belongs_to(arr, options={})
        arr.to_a.each {|obj| belongs_to obj.to_sym, options }
      end
    end
  end
end
