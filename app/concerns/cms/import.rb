module Cms
  module Import
    extend ActiveSupport::Concern
    
    module ClassMethods
      def define_import(kols)
        import_attributes = kols.inject({}) do |ret, kol|
          k = kol.to_s.split('_').join.to_sym
          v = kol.to_sym
          
          ret[k] = v
          ret
        end
        
        define_cattr :import_columns, import_attributes
        true
      end
    end
  end
end
