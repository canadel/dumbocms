module Cms
  module State
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      def define_state(col, states)
        class_eval do
          include AASM
        end
        
        col = col.to_sym
        init = states.first.to_sym
        
        aasm_column col
        aasm_initial_state init
        
        states.flatten.each do |st|
          st = st.to_sym
          
          aasm_state st
          scope st, where(col => st.to_s)
        end

        prev = [init]

        states.each do |st|
          st = [st] unless st.is_a?(Array)
          st = st.map(&:to_sym)
          
          next if st == prev
          
          st.each do |s|
            aasm_event(s) do
              transitions to: s, from: prev
            end
          end
          
          prev = st
        end
        
        true
      end
    end
  end
end