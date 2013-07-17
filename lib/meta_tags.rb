require 'meta_tags/container'
require 'meta_tags/page_data_helper'
require 'meta_tags/controller'


module MetaTags

  mattr_accessor :title_methods
  @@title_methods = %w(title name)

  mattr_accessor :description_methods
  @@description_methods = %w(description desc content)

  mattr_accessor :image_methods
  @@image_methods = %w(image picture avatar)

  def self.config
    yield self if block_given?
  end

  ActionController::Base.send(:include, Controller)
end


