require "meta_tags/engine"

module MetaTags
  extend ActiveSupport::Autoload

  autoload :Controller
  autoload :MetaTaggable
  autoload :MetaTaggableMacro
  autoload :Renderer
  autoload :Store
  autoload :Tags
  autoload :Vendors
  autoload :ViewHelpers

  mattr_accessor :title_methods
  @@title_methods = %w(title name)

  mattr_accessor :description_methods
  @@description_methods = %w(description desc content)

  mattr_accessor :image_methods
  @@image_methods = %w(image picture avatar)

  mattr_accessor :defaults
  @@defaults = nil

  class << self
    def config
      yield self if block_given?
    end

    def table_name_prefix
      'meta_tags_'
    end
  end
end
