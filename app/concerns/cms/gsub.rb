module Cms
  module Gsub
    extend ActiveSupport::Concern

    module ClassMethods
      
      def define_gsub(cols, pattern=nil, replacement=nil)
        cols = cols.map(&:to_sym)
        pattern ||= /[ \t\r\n]/
        replacement ||= ''
        
        cols.each do |col|
          class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
            before_save do
              return true if self.#{col}.blank?
              
              self.#{col} = self.#{col}.gsub(/#{pattern}/, '#{replacement}')
              true
            end
          ruby_eval
        end
        
        true
      end
      
    end
  end
end