class AddSomeSettings < ActiveRecord::Migration
  def self.up
    Setting.create!(:key => "document.default_markup",    :value => nil)
    Setting.create!(:key => "document.default_priority",  :value => 100)
  end

  def self.down
    Setting.find_by_key("document.default_markup").destroy!   rescue nil
    Setting.find_by_key("document.default_priority").destroy! rescue nil
  end
end
