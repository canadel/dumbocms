class AddSettingsEmailFrom < ActiveRecord::Migration
  def self.up
    Setting.create!(
      :key    => 'service.email_form.default_from',
      :value  => 'dumbocms@dumbocms.com'
    )
    Setting.create!(
      :key    => 'service.email_form.default_subject',
      :value  => 'An inquiry'
    )
  end

  def self.down
    begin
      Setting.find_by_key('service.email_form.default_subject').destroy!
    rescue
      nil
    end
    
    begin
      Setting.find_by_key('service.email_form.default_from').destroy!
    rescue
      nil
    end
  end
end
