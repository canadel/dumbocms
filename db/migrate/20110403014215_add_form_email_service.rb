class AddFormEmailService < ActiveRecord::Migration
  def self.up
    Service.create({
      :slug => "email_form"
    }) if defined?(Service)
  end

  def self.down
  end
end
