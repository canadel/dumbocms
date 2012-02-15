class PropagateTimezones < ActiveRecord::Migration
  def self.up
    [Account, Document, Page, Company].each do |klass|
      klass.update_all(:timezone => 'Europe/Berlin')
    end
  end

  def self.down
  end
end
