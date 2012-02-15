module Cms
  module ExternalId
    extend ActiveSupport::Concern
  
    module ClassMethods
      
      #--
      # FIXME:
      #
      #   1) Error:
      # test_create_valid(Api::V1::PagesTest):
      # NoMethodError: undefined method `increment!' for nil:NilClass
      #     app/concerns/cms/external_id.rb:24:in `set_external_id'
      #     test/integration/api/v1/pages_test.rb:59:in `test_create_valid'
      #
      #   1) Error:
      # test_create(Api::V1::DocumentsValidTest):
      # NoMethodError: undefined method `increment!' for nil:NilClass
      #     app/concerns/cms/external_id.rb:33:in `set_external_id'
      #     test/integration/api/v1/documents_valid_test.rb:63:in `test_create'
      #++
      def define_external_id(options={})
        options = options.symbolize_keys
        options.assert_valid_keys(:on)
        
        myself = self.table_name
        parent = options.fetch(:on).to_sym
        counter = "#{myself}_external_id".to_sym
        
        # class_eval do
        #   before_create do
        #     self.send(parent).increment!(counter)
        #     self.external_id = send(parent).send(counter)
        #     true
        #   end
        # end
        
        define_method(:set_external_id) do
          self.send(parent).increment!(counter)
          self.external_id = send(parent).send(counter)
          true
        end
        
        before_create :set_external_id
        true
      end
    end
  end
end