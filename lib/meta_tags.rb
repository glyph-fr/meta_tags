require "meta_tags/engine"

module MetaTags
  mattr_accessor :title_methods
  @@title_methods = %w(title name)

  mattr_accessor :description_methods
  @@description_methods = %w(description desc content)

  mattr_accessor :image_methods
  @@image_methods = %w(image picture avatar)

  mattr_accessor :separator
  @@separator = '-'

  mattr_accessor :keep_default_title_present
  @@keep_default_title_present = true

  class << self
    def config
      yield self if block_given?
    end

    def table_name_prefix
      'meta_tags_'
    end
  end
end
