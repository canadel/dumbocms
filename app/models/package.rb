class Package < ActiveRecord::Base
  belongs_to :template
  has_and_belongs_to_many :presets
  has_one :mobile_package, :class_name => 'Package', :foreign_key => 'mobile_package_id'

  validates :name, presence: true
  validates :template_id, presence: true, numericality: { greater_than: 0 }
end
