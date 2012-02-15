class BulkImport < ActiveRecord::Base
  include Cms::Base

  define_cattr :fastercsv_options, {
    :headers => true,
    :return_headers => false,
    :skip_blanks => true,
    :header_converters => :symbol,
    :converters => [:integer, :date, :string]
  }
  define_parent :account
  define_default %w{domain_ids page_ids}, []
  define_default %w{output}, {}
  define_serialize %w{domain_ids page_ids}, ::Array
  define_serialize %w{output}, ::Hash
  define_state :state, [:uploaded, :processing, [:failure, :success]]
  define_enum :record, %w{domain page category}
  
  default_scope latest()
  
  has_attached_file :csv
  
  class << self
    # Process all imports in the queue.
    def process!
      uploaded.find_each(:batch_size => 5) do |import|
        import.transaction do
          import.lock!
          next if import.processing?

          import.processing!
          import.process!
          import.processed!
        end
      end

      true
    end
  end

  def process!
    skope = (record == 'domain') ? {} : { :account_id => self.account_id } # FIXME
    
    FasterCSV.open(self.csv.path, 'r', fastercsv_options) do |csv|
      csv.each do |row|
        attrs = row.inject({}) do |ret, e|
          col, v = record_column(e.first), e.last
          ret[col] = v if col.present? && v.present?
          ret
        end
        
        next if attrs.all? {|k, v| v.blank? || v == '0' } # FIXME

        imported = record_class.import!(attrs.merge(skope))
        self.output[csv.lineno] = imported.errors if imported.invalid?
      end
    end
    
    save(:validate => false)
    true
  end
  
  # Mark the import as either a success, or a failure.
  def processed!
    output.empty? ? success! : failure!
  end
  
  # Return the state, with an indicating color.
  def state_html
    case state.to_sym
    when :uploaded
      'waiting'
    else
      'done'
    end
  end
  
  # Return the import's output as a HTML.
  def output_html
    meth = "output_#{state}_html"
    respond_to?(meth) ? send(meth).html_safe : nil
  end
  
  protected
    def output_failure_html
      ret = []
      
      output.each do |lineno, errors|
        errors.each do |column, message|
          ret << "Row #{lineno} #{column} #{message}"
        end
      end
      
      ret.join("<br />")
    end
    
  private
    # Record the record's class.
    def record_class
      @record_class ||= record.titleize.constantize
    end
    
    # Record the record's column.
    def record_column(header)
      @record_column ||= {}
      @record_column[header] ||= record_class.import_columns[header]
    end
end