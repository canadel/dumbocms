class AddAppsSlugs < ActiveRecord::Migration
  def self.up
    app = App.find_by_id(1)
    app.update_attribute(:slug, 'nothing') if app
    
    app = App.find_by_id(2)
    app.update_attribute(:slug, 'search') if app
  end

  def self.down
  end
end
