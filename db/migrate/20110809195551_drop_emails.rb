class DropEmails < ActiveRecord::Migration
  def self.up
    drop_table :emails
  end

  def self.down
  end
end
