class AddSettingsServiceDevelopmentTo < ActiveRecord::Migration
  def self.up
    Setting.create({
      :key    => "service.email_form.development_to",
      :value  => "dumbocms@dumbocms.com"
    })
  end

  def self.down
    begin
      Setting.find_by_key("service.email_form.development_to").destroy! 
    rescue
      nil
    end
  end
end
