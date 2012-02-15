module Cms
  module Propagate
    extend ActiveSupport::Concern
  
    module ClassMethods
      # define_propagate :permalinks, :documents, :permalink!
      def define_propagate(what, whom, how)
        define_method("propagate_#{what}".to_sym) do
          return true unless send("#{what}_changed?".to_sym)
          
          send(whom.to_sym).each {|obj| obj.send(how) }
          true
        end
      end
    end
  end
end