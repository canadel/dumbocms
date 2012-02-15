class CreateServices < ActiveRecord::Migration
  def self.up
    begin
      create_table :services do |t|
        t.string :slug
        t.timestamps
      end
    rescue
      nil
    end
  end

  def self.down
    drop_table :services
  end
end
