module Cms
  module Timezone
    extend ActiveSupport::Concern
    
    module ClassMethods

      def define_timezone(kolumn=nil)
        kolumn ||= :timezone
        kolumn = kolumn.to_sym
        
        define_selector kolumn, ::ActiveSupport::TimeZone::MAPPING.values

        true
      end
      
      alias_method :define_tz, :define_timezone
    end
  end
end