# A hacky migration that ensures that all documents have a template.
class EnsureDocumentsTemplate < ActiveRecord::Migration
  def self.up
    Document.all.each do |doc|
      next if doc.template_id.to_s.present?

      doc.update_attribute(:template_id, doc.document_template.id)
      puts "#{doc.id} #{doc.template_id}" # FIXME
    end
  end

  def self.down
    # TODO
  end
end
