module Cms
  module Matching
    extend ActiveSupport::Concern
  
    module ClassMethods
      #--
      #   1) Failure:
      # test_getPost_categories(MetaWeblogApiTest) [test/functional/meta_weblog_api_test.rb:79]:
      # <["name99", "name100", "name101"]> expected but was
      # <["name100", "name101", "name99"]>.
      #++
      def define_matching(cols)
        define_cattr(:matching_attributes, cols)
      end
      
      def many_matching(q)
        # return nil unless self.methods.include?(:matching_attributes)
        
        q.to_a.inject([]) do |ret, c|
          cat = self.matching(c)
          ret << cat if !cat.nil? && !ret.include?(cat)
          ret
        end
      end
      
      def matching(q)
        # return nil unless self.methods.include?(:matching_attributes)
        return nil if q.nil?
        q = q.to_s.strip # TODO: required? move to other places?

        self.matching_attributes.each do |mattr|
          # FIXME: where("external_id = ?", q.to_i).first()
          ret = where("LOWER(#{mattr.to_s}) = ?", q.to_s.downcase)
          return ret.first() unless ret.empty?
        end
        
        nil
      end
    end
  end
end