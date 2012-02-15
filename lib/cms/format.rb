module Cms
  module Format
    # 66669
    # 66669-1234
    ZIP_CODE = /^(\d{5}|\d{5}-\d{4})$/
    URL = /^https?:\/\/\S+$/
    SLUG = /^[a-zA-Z0-9_\/\-]+$/
  end
end