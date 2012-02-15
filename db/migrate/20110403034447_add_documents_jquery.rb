class AddDocumentsJquery < ActiveRecord::Migration
  def self.up
    Document.create!({
      :slug     => 'jquery',
      :global   => true,
      :eternal  => true,
      :content  => <<-EOF
http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js
EOF
    }) if false
  end

  def self.down
    begin
      Document.find_by_slug('jquery').destroy!
    rescue
      nil
    end
  end
end
