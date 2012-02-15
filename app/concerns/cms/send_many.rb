module Cms
  module SendMany
    extend ActiveSupport::Concern
  
    included do
      #--
      # TODO: Are these methods safe?
      #++
      alias_method :many, :send_many
      alias_method :pick, :send_many
      alias_method :take, :send_many
    end
    
    module InstanceMethods
      
      def send_many(*args)
        [args.to_a].flatten.map {|meth| self.send(meth) }
      end
    end
  end
end