class RemovePrioritiesAgain < ActiveRecord::Migration
  def self.up
    Setting.find_by_key('document.default_priority').destroy! rescue nil
  end

  def self.down
  end
end
