class AddPagesGoogleAnalyticsTrackingCode < ActiveRecord::Migration
  def self.up
    add_column :pages, :google_analytics_tracking_code, :string
  end

  def self.down
    remove_column :pages, :google_analytics_tracking_code
  end
end