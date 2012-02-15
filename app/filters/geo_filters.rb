require 'set'

module GeoFilters #:nodoc:
  include CmsFilters

  GEO_CLASSES = [String, Hash, Document, Page].to_set.freeze
  
  # See http://goo.gl/Qa7AT for reference.
  GEO_MAP_TYPES = %w(roadmap satellite terrain hybrid).to_set.freeze
  
  # See http://goo.gl/c8xWb for reference.
  GEO_IMAGE_TYPES = %w(png8 png png32 gif jpg jpg-baseline).to_set.freeze
  
  # A gmaps_staticmap returns a Google Maps image.
  #
  # Quoting the first paragraph of Google Maps Image APIs:
  #
  #   The Google Static Maps API lets you embed a Google Maps image on your
  #   web page without requiring JavaScript or any dynamic page loading.
  #   The Google Static Map service creates your map based on URL parameters
  #   sent through a standard HTTP request and returns the map as an image
  #   you can display on your web page.
  #
  # Please note the first param is a comma-separeted latitude,longitude
  # pair. The filter, though, is fairly liberal, and does handle redundant
  # spaces nicely, by shifting them. We do not advertise this incorrect 
  # behavior for the sake of good.
  # ==== Examples
  #   {{ }}
  #   # => http://maps.googleapis.com/maps/api/staticmap?center=-15.800513,-47.91378&zoom=11&size=200x200
  def gmaps_staticmap(center, zoom, horizontal=nil, vertical=nil, maptype=nil, format=nil) # FIXME style
    horizontal = horizontal.blank? ? 300 : horizontal.to_i
    vertical = vertical.blank? ? 300 : vertical.to_i
    maptype ||= 'roadmap'
    format ||= 'png'
    
    assert_center!(center)
    assert_horizontal!(horizontal)
    assert_vertical!(vertical)
    assert_maptype!(maptype)
    assert_format!(format)
    
    coordinates = coordinates(center)
    assert_coordinates!(coordinates)
    
    lat, lng = coordinates
    
    ret = <<-EOF
http://maps.googleapis.com/maps/api/staticmap?
  center=#{lat},#{lng}&
  zoom=#{zoom}&
  size=#{horizontal}x#{vertical}
EOF
    ret.split(/[\n ]/).join('').html_safe
  end
  
  # A gmaps_embed returns a Google Maps embedded, exactly like
  # http://maps.google.com/ does.
  #
  # Please note the first param is a comma-separeted latitude,longitude
  # pair. The filter, though, is fairly liberal, and does handle redundant
  # spaces nicely, by shifting them. We do not advertise this incorrect 
  # behavior for the sake of good.
  # ==== Examples
  #   {{ }}
  #   # => http://maps.googleapis.com/maps/api/staticmap?center=-15.800513,-47.91378&zoom=11&size=200x200
  def gmaps_embed(center, zoom, horizontal=nil, vertical=nil)
    horizontal = horizontal.blank? ? 300 : horizontal.to_i
    vertical = vertical.blank? ? 300 : vertical.to_i
    maptype ||= 'roadmap'
    format ||= 'png'
    
    assert_center!(center)
    assert_horizontal!(horizontal)
    assert_vertical!(vertical)
    
    coordinates = coordinates(center)
    assert_coordinates!(coordinates)
    
    lat, lng = coordinates
    
    src = "http://maps.google.com/?ie=UTF8&amp;ll=#{lat},#{lng}&amp;spn=#{lat},#{lng}&amp;t=h&amp;z=#{zoom}&amp;vpsrc=0&amp" # FIXME style
    ret = <<-EOF
<iframe width="#{horizontal}" height="#{vertical}" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="#{src};output=embed"></iframe><br /><small><a href="#{src};source=embed" style="color:#0000FF;text-align:left">View Larger Map</a></small>
EOF
    ret.split(/[\n]/).join('').html_safe
  end
  
  protected
    # FIXME return
    def coordinates(center)
      return center.coordinates if center.respond_to?(:coordinates)
      
      case center.class.name.to_sym
      when :String
        center.split(',').map do |co|
          co.gsub(/^ /, '').gsub(/ $/, '') # FIXME: String#shift
        end
      when :Hash
        center = center.stringify_keys
        
        ([]).tap do |co|
          co << center['latitude']
          co << center['longitude']
        end
      end
    end
  
    def assert_coordinates!(coordinates)
      if coordinates.blank? || coordinates.any? {|co| co.blank? }
        msg = <<-EOF
Filter gmaps_staticmap requires both coordinates set
EOF
        raise SyntaxError.new(msg.split('\n').join(''))
      end
      
      if coordinates.size != 2
        msg = <<-EOF
Filter gmaps_staticmap requires only two comma-separated coordinates
EOF
        raise SyntaxError.new(msg.split('\n').join(''))
      end
    end
    
    # See http://goo.gl/tyPyG for reference.
    def assert_horizontal!(horizontal)
      if horizontal > 640
        msg = <<-EOF
Filter gmaps_staticmap supports maximum 640 horizontal
EOF
        raise SyntaxError.new(msg.split('\n').join(''))
      end
    end
    
    # See http://goo.gl/tyPyG for reference.
    def assert_vertical!(vertical)
      if vertical > 640
        msg = <<-EOF
Filter gmaps_staticmap supports maximum 640 horizontal
EOF
        raise SyntaxError.new(msg.split('\n').join(''))
      end
    end
    
    def assert_center!(center)
      unless GEO_CLASSES.member?(center.class)
        msg = <<-EOF
Filter gmaps_staticmap expects any of coordinates, document, or page as
the first parameter
EOF
        raise SyntaxError.new(msg.split('\n').join('')) # FIXME: String#shift
      end
    end
    
    def assert_maptype!(maptype)
      unless GEO_MAP_TYPES.member?(maptype)
        msg = <<-EOF
Filter gmaps_staticmap supports #{GEO_MAP_TYPES.join(", ")} map types
EOF
        raise SyntaxError.new(msg.split('\n').join('')) # FIXME: String#shift
      end
    end
    
    def assert_format!(format)
      unless GEO_IMAGE_TYPES.member?(format)
        msg = <<-EOF
Filter gmaps_staticmap supports #{GEO_IMAGE_TYPES.join(", ")} formats
EOF
        raise SyntaxError.new(msg.split('\n').join('')) # FIXME: String#shift
      end
    end
end