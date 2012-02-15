module Cms
  module Parent
    extend ActiveSupport::Concern

    module ClassMethods
      def define_parent(kolumns, options={})
        kolumns = [kolumns] unless kolumns.is_a?(Array)
        kolumns = kolumns.map(&:to_sym)
        
        kolumns.each do |kolumn|
          kolumn, kolumn_id = kolumn.to_sym, "#{kolumn}_id".to_sym
          belongs_to kolumn, options
        end
        
        # validates kolumn, :associated => true
        # validates kolumn_id,
        #   :presence => true,
        #   :numericality => { :greater_than => 0 }
      end
    end
  end
end