class SeedApps < ActiveRecord::Migration
  def self.up
    App.create({
      :description  => "do nothing"
    })
    
    SearchApp.create({
      :description  => "return matching documents"
    })
    
    FormApp.create({
      :description  => "send a form to a customer"
    })
  end

  def self.down
  end
end
