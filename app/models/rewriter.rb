class Rewriter < ActiveRecord::Base
  include Cms::Base
  
  define_parent :account
  define_default :position, 100

  validates :pattern, :presence => true
  
  default_scope ordered()
  
  class << self
    # Rewrite the content using all rewriters.
    def rewrite!(content)
      all.inject(nil) {|ret, rewriter| rewriter.rewrite!(ret) }
    end
  end

  # Rewrite the content using the rewriter.
  def rewrite!(content)
    return content unless match?
    
    content.gsub(/#{pattern}/, replacement)
  end
  
  protected
    # Return true if content matches.
    def match?(content)
      self.match.present? && content =~ /#{self.match}/
    end
end