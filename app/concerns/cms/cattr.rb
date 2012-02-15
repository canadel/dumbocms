module Cms
  module Cattr
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      def define_cattr(kol, v)
        v = v.map(&:to_s).sort.freeze if v.is_a?(Array)
        
        class_attribute(kol.to_sym)
        send("#{kol}=", v)
        
        true
      end
    end
    
  end
end