module Cms
  module Strip
    extend ActiveSupport::Concern

    module ClassMethods
      
      def define_strip(cols, pattern=nil)
        define_gsub(cols, /[ \t\r\n]/, '')
        true
      end
      
      alias_method :define_strips, :define_strip
    end
  end
end