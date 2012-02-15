class AddCoordinates < ActiveRecord::Migration
  def self.up
    add_column :pages, :latitude, :float
    add_column :pages, :longitude, :float
    
    add_column :documents, :latitude, :float
    add_column :documents, :longitude, :float
  end

  def self.down
    remove_column :documents, :longitude
    remove_column :documents, :latitude
    
    remove_column :pages, :longitude
    remove_column :pages, :latitude
  end
end