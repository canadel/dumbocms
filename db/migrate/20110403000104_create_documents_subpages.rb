class CreateDocumentsSubpages < ActiveRecord::Migration
  def self.up
    create_table :documents_subpages, :force => true, :id => false do |t|
      t.integer :subpage_id
      t.integer :document_id
    end
  end

  def self.down
    drop_table :documents_subpages
  end
end