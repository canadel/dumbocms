module Cms
  module Scopes
    extend ActiveSupport::Concern
    
    included do
      if self.column_names.include?('position')
        scope :ordered, order("#{table_name}.position ASC")
      end
      
      if self.column_names.include?('published_at') # TODO: Overwrite?
        scope :latest, order('published_at DESC')
        scope :oldest, order('published_at ASC')
      else
        scope :latest, order('updated_at DESC')
        scope :oldest, order('updated_at ASC')
      end
      
      self.columns_hash.each do |k, v|
        #--
        # Account.columns_hash['name']
        # => #<ActiveRecord::ConnectionAdapters::Mysql2Column:0x104550d70 @name="name", @precision=nil, @primary=false, @type=:string, @null=true, @default=nil, @limit=255, @sql_type="varchar(255)", @scale=nil>
        #++
        
        name, typ = v.name.to_sym, v.type
        abbr = name.to_s.gsub(/_at$/, '').to_sym
        t_meth, f_meth = abbr.to_sym, "not_#{abbr}".to_sym

        case typ
        when :boolean
          scope t_meth, where(name => true)
          scope f_meth, where(name => false)
        when :date, :datetime
          self.class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
            scope t_meth, lambda { where("#{name} <= ?", Time.now) }
            scope f_meth, lambda { where("#{name} > ?", Time.now) }
            
            def #{t_meth}?
              !#{name}.nil? && #{name} <= Time.now
            end
            
            def #{f_meth}?
              !#{name}?
            end
          ruby_eval
        when :string
          # self.class_eval <<-ruby_eval, __FILE__, __LINE__ + 1
          #   scope t_meth, lambda {|q| where("LOWER(#{name}) = ?", q.to_s.downcase)}
          # ruby_eval
        end
      end
      
    end    
  end
end