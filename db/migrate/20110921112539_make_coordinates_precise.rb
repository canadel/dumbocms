class MakeCoordinatesPrecise < ActiveRecord::Migration
  def self.up
    change_column :pages, :latitude, :decimal, :precision => 10, :scale => 6
    change_column :pages, :longitude, :decimal, :precision => 10, :scale => 6
    
    change_column :documents, :latitude, :decimal, :precision => 10, :scale => 6
    change_column :documents, :longitude, :decimal, :precision => 10, :scale => 6
  end

  def self.down
    change_column :pages, :latitude, :double
    change_column :pages, :longitude, :double
    change_column :documents, :latitude, :double
    change_column :documents, :longitude, :double
  end
end