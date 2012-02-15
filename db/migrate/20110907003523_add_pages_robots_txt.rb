class AddPagesRobotsTxt < ActiveRecord::Migration
  def self.up
    add_column :pages, :robots_txt, :text
  end

  def self.down
    remove_column :pages, :robots_txt
  end
end