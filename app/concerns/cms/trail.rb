module Cms
  module Trail
    extend ActiveSupport::Concern

    included do
      has_paper_trail # unless Rails.env.test?
    end
  end
end