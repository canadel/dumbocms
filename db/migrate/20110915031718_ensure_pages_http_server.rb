class EnsurePagesHttpServer < ActiveRecord::Migration
  def self.up
    Page.update_all ['http_server = ?', Rails.configuration.dumbocms.http_server]
  end

  def self.down
    Page.update_all ['http_server = ?', nil]
  end
end