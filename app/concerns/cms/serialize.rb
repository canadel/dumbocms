module Cms
  module Serialize
    extend ActiveSupport::Concern
    
    module ClassMethods
      def define_serialize(arr, options={})
        arr.to_a.each {|obj| serialize obj.to_sym, options }
      end
    end
  end
end
