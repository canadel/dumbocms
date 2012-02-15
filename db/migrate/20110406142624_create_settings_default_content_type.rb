class CreateSettingsDefaultContentType < ActiveRecord::Migration
  def self.up
    Setting.create({
      :key    => 'subpage.default_content_type',
      :value  => 'text/html'
    })
  end

  def self.down
    Setting.find_by_key('subpage.default_content_type').destroy! rescue nil
  end
end
