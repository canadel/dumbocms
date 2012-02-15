class AddCategoriesDocuments < ActiveRecord::Migration
  def self.up
    create_table :categories_documents, :force => true, :id => false do |t|
      t.integer :category_id
      t.integer :document_id
    end
  end

  def self.down
    drop_table :categories_documents
  end
end