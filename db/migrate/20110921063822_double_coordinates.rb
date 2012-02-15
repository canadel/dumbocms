class DoubleCoordinates < ActiveRecord::Migration
  def self.up
    change_column :pages, :latitude, :double
    change_column :pages, :longitude, :double
    change_column :documents, :latitude, :double
    change_column :documents, :longitude, :double
  end

  def self.down
    change_column :documents, :longitude, :float
    change_column :documents, :latitude, :float
    change_column :pages, :longitude, :float
    change_column :pages, :latitude, :float
  end
end