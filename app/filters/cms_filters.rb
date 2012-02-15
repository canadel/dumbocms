require 'erb'
require 'set'

module CmsFilters
  
  protected
    def logger
      ::Rails.logger
    end
    
    # Reference:
    #
    # https://github.com/rails/rails/blob/95a5bd87cb542c534b7f2490dcfa687a1bfeec43/actionpack/lib/action_view/helpers/tag_helper.rb
    BOOLEAN_ATTRIBUTES = %w(disabled readonly multiple checked autobuffer
      autoplay controls loop selected hidden scoped async
      defer reversed ismap seemless muted required
      autofocus novalidate formnovalidate open pubdate).to_set
    BOOLEAN_ATTRIBUTES.merge(BOOLEAN_ATTRIBUTES.map {|atr| atr.to_sym })
          
    # Reference:
    #
    # https://github.com/rails/rails/blob/95a5bd87cb542c534b7f2490dcfa687a1bfeec43/actionpack/lib/action_view/helpers/tag_helper.rb
    def tag(name, options=nil, open=false, escape=true)
      "<#{name}#{tag_options(options, escape) if options}#{open ? ">" : " />"}".html_safe # FIXME style
    end
    
    # Reference:
    #
    # https://github.com/rails/rails/blob/95a5bd87cb542c534b7f2490dcfa687a1bfeec43/actionpack/lib/action_view/helpers/tag_helper.rb
    def tag_options(options, escape=true)
      unless options.blank?
        attrs = []
        options.each_pair do |key, value|
          if key.to_s == 'data' && value.is_a?(Hash)
            value.each do |k, v|
              if !v.is_a?(String) && !v.is_a?(Symbol)
                v = v.to_json
              end
              v = ERB::Util.html_escape(v) if escape
              attrs << %(data-#{k.to_s.dasherize}="#{v}")
            end
          elsif BOOLEAN_ATTRIBUTES.include?(key)
            attrs << %(#{key}="#{key}") if value
          elsif !value.nil?
            final_value = value.is_a?(Array) ? value.join(" ") : value
            final_value = ERB::Util.html_escape(final_value) if escape
            attrs << %(#{key}="#{final_value}")
          end
        end
      " #{attrs.sort * ' '}".html_safe unless attrs.empty?
      end
    end
end