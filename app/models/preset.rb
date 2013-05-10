class Preset < ActiveRecord::Base
  belongs_to :template
  has_and_belongs_to_many :packages

  validates :slug, :title, presence: true
  validates :template_id, presence: true, numericality: { greater_than: 0 }
end
