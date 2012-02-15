class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.string :body

      t.string :by
      t.boolean :waiting
      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
